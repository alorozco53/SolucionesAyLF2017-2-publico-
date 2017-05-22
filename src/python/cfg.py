#! /usr/bin/python
# -*- coding: utf-8 -*-

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import os
import argparse

class CFG:
    """A class that models a context-free grammar.
    Parameters:
    :verbose_mode flag: True or False
    :N: list of non-terminals
    :V: list of terminals
    :P: dictionary of productions
    :S: initial symbol
    """

    def __init__(self, verbose_mode,
                 terminals=None,
                 non_terminals=None,
                 initial_symbol=None,
                 productions=None,
                 epsilon='!'):
        # check that terminals and non_terminals are disjoint
        if terminals is not None and non_terminals is not None:
            assert set(terminals).isdisjoint(set(non_terminals))

        # check that the initial symbol is in the set of non-terminals
        if initial_symbol is not None and non_terminals is not None:
            assert initial_symbol in non_terminals

        self.verbose = verbose_mode
        self.V = set(terminals) if terminals is not None else None
        self.N = set(non_terminals) if non_terminals is not None else None
        self.P = productions
        self.S = initial_symbol

        if self.V:
            assert epsilon not in self.V
        if self.N:
            assert epsilon not in self.N
        self.epsilon = epsilon

    def in_cnf(self):
        """Decides if self is in Chomsky normal form
        """
        assert self.P is not None
        for _, bodies in self.P.items():
            for body in bodies:
                if len(body) == 1:
                    if body[0] in self.N:
                        return False
                elif len(body) == 2:
                    if body[0] in self.V or body[1] in self.V:
                        return False
                else:
                    return False
        return True

    def parse_from_file(self, filepath='grammar.cfg'):
        """Parses a grammar in 'waterloo' format. See [https://www.student.cs.uwaterloo.ca/~cs241/cfg/cfg.html], and
        [../README.md](the readme) for more info.
        """
        assert os.path.exists(filepath)
        with open(filepath, 'r') as f:
            state = 0
            for line in f:
                cont = line.strip()
                if state == 0:
                    t = int(cont)
                    assert t >= 0
                    state = 1 if t > 0 else 2
                elif state == 1:
                    assert cont != self.epsilon
                    if self.V is None:
                        self.V = [cont]
                    else:
                        self.V.append(cont)
                    t -= 1
                    if t == 0:
                        state = 2
                elif state == 2:
                    n = int(cont)
                    assert n >= 0
                    state = 3 if n > 0 else 4
                elif state == 3:
                    assert cont != self.epsilon
                    if self.N is None:
                        self.N = [cont]
                    else:
                        self.N.append(cont)
                    n -= 1
                    if n == 0:
                        state = 4
                elif state == 4:
                    assert cont in self.N
                    self.S = cont
                    state = 5
                elif state == 5:
                    r = int(cont)
                    state = 6
                    if r <= 0:
                        break
                elif state == 6:
                    tokenized = cont.split()
                    assert tokenized != []
                    lhs = tokenized[0]
                    rhs = tokenized[1:]
                    if rhs == []:
                        rhs = [self.epsilon]
                    assert lhs in self.N
                    for symb in rhs:
                        assert symb in self.N or symb in self.V or symb == self.epsilon
                    if self.P is None:
                        self.P = {lhs: set([tuple(rhs)])}
                    else:
                        try:
                            self.P[lhs].add(tuple(rhs))
                        except KeyError:
                            self.P[lhs] = set([tuple(rhs)])
                    r -= 1
                    if r == 0:
                        break
        self.V = set(self.V)
        self.N = set(self.N)

    def remove_epsilons(self):
        """
        Removes productions with the form A -> self.epsilon from the grammar
        """
        assert self.P is not None
        # identify non-terminals with epsilon productions
        epsilon_nts = []
        for head, bodies in self.P.items():
            for body in bodies:
                if body == tuple(self.epsilon):
                    epsilon_nts.append(head)

        # add new productions
        new_prods = {}
        for ep in epsilon_nts:
            for head, bodies in self.P.items():
                for body in bodies:
                    for i, sym in enumerate(body):
                        if ep == sym:
                            try:
                                new_prods[head].add(body[:i] + body[i+1:])
                            except KeyError:
                                new_prods[head] = {body[:i] + body[i+1:]}
        for np, bs in new_prods.items():
            self.P[np] = self.P[np].union(bs)

        # delete epsilon productions
        for ep in epsilon_nts:
            self.P[ep].discard(tuple(self.epsilon))

    def remove_unit_productions(self):
        """
        Removes productions with the form A -> B, where A and B are in self.N
        """
        assert self.P is not None

        while True:
            # identify non_terminals with unit productions
            unit_prods = []
            for head, bodies in self.P.items():
                for body in bodies:
                    if len(body) == 1 and body[0] in self.N:
                        unit_prods.append((head, body[0]))

            if len(unit_prods) == 0:
                break

            # remove unit productions
            for h, b in unit_prods:
                try:
                    self.P[h] = self.P[h].union(self.P[b])
                except KeyError:
                    pass
                self.P[h].discard(tuple([b]))


    def new_nt(self, prefix='A'):
        """
        Generates a new non terminal symbol, with the given prefix.
        :returns str: a brand new symbol not included in self.N
        REMARK: This method doesn't update self.N!
        """
        count = 0
        while True:
            candidate = prefix + str(count)
            if candidate not in self.N:
                return candidate
            count += 1
        return None

    def remove_terminals(self):
        """
        Given a production A -> alpha, where alpha is a non-unit sentennial,
        removes any terminal a in alpha by adding a new non-terminal Aa -> a, and
        substituting Aa in all occurrences
        """
        assert self.P is not None

        # check for terminals
        terminals = {}
        for _, bodies in self.P.items():
            for body in bodies:
                if len(body) > 1:
                    for symb in body:
                        if symb in self.V:
                            nnt = self.new_nt()
                            if symb not in terminals.keys():
                                self.N.add(nnt)
                                terminals[symb] = nnt

        # make replacements
        new_bodies = {}
        trash = {}
        for head, bodies in self.P.items():
            for body in bodies:
                if len(body) > 1:
                    tmp = list(body)
                    for i in range(len(tmp)):
                        try:
                            tmp[i] = terminals[tmp[i]]
                        except KeyError:
                            pass
                    try:
                        new_bodies[head].add(tuple(tmp))
                        trash[head].add(body)
                    except KeyError:
                        new_bodies[head] = {tuple(tmp)}
                        trash[head] = {body}

        # rearrange grammar
        for k in new_bodies.keys():
            for item in trash[k]:
                self.P[k].discard(item)
            for item in new_bodies[k]:
                self.P[k].add(item)
        for k, b in terminals.items():
            self.P[b] = {tuple([k])}

    def to_cnf(self):
        """
        Transforms the current grammar to Chomsky normal form
        """
        assert self.P is not None

        if not self.in_cnf():
            # remove epsilons, unit productions and terminals
            self.remove_epsilons()
            self.remove_unit_productions()
            self.remove_terminals()

            # identify all sentennials with length greater than 2
            large_sents = {}
            for head, bodies in self.P.items():
                for body in bodies:
                    if len(body) > 2:
                        try:
                            large_sents[head].add(body)
                        except KeyError:
                            large_sents[head] = {body}

            # Factor all needed strings from each large sentennial and
            # remove large sentennials
            factored_sents = {}
            for head, bodies in large_sents.items():
                for sent in bodies:
                    self.P[head].discard(sent)
                    suffix = sent[1:]
                    pref = tuple([sent[0]])
                    dummy_head = head
                    while True:
                        new_head = self.new_nt(prefix='Z')
                        self.N.add(new_head)
                        new_body = pref + tuple([new_head])
                        try:
                            self.P[dummy_head].add(new_body)
                        except KeyError:
                            self.P[dummy_head] = {new_body}
                        if len(suffix) > 2:
                            pref = tuple([suffix[0]])
                            suffix = suffix[1:]
                            dummy_head = new_head
                        else:
                            self.P[new_head] = {suffix}
                            break

    def cky(self, input_str):
        """
        Iterative implementation of the Cocke-Kasami-Younger algorithm for parsing.
        Parameter:
        :input_str: string to be parsed
        """
        assert self.P is not None
        try:
            assert self.in_cnf()
        except AssertionError:
            print('This grammar is not in CNF! Please call self.to_cnf()')
            return

        # pre-process input string
        w = input_str.split()

        # non-terminal matrix
        matrix = [[set() for _ in range(len(w) + 1)] for _ in range(len(w) + 1)]

        # check all unit substrings
        for i in range(len(w)):
            for head, bodies in self.P.items():
                for body in bodies:
                    if len(body) == 1:
                        if body[0] == w[i:i+1][0]:
                            matrix[i][i+1].add(head)

        # check substrings of length > 1
        for m in range(2, len(w)+1):
            for i in range(0, len(w)-m+1):
                for j in range(i+1, i+m):
                    for head, bodies in self.P.items():
                        for body in bodies:
                            if len(body) == 2:
                                if body[0] in matrix[i][j] and body[1] in matrix[j][i+m]:
                                    matrix[i][i+m].add(head)

        if self.verbose:
            for l in matrix:
                print(l)
        return self.S in matrix[0][len(w)]

    def __str__(self):
        """
        Provides general info of the contents of the current instance.
        """
        info = 'Terminals:\n'
        for term in self.V:
            info += '\t{}\n'.format(term)
        info += '\nNon-terminals:\n'
        for nt in self.N:
            info += '\t{}\n'.format(nt)
        info += '\nStart symbol:\n'
        info += '\t{}\n'.format(self.S)
        info += '\nProduction rules:\n'
        for head, bodies in self.P.items():
            for body in bodies:
                rule = '\t{} -> '.format(head)
                for sym in body:
                    rule += '{} '.format(sym)
                info += '{}\n'.format(rule)
        return info


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='script\'s argument parser')
    parser.add_argument('-g', help='grammar file path to be used', default='grammar.cfg')
    parser.add_argument('-w', help='string to be parsed')
    parser.add_argument('-v', help='verbose mode', action='store_true')
    args = parser.parse_args()
    cfg = CFG(args.v)
    cfg.parse_from_file(args.g)
    print('Recognized grammar:')
    print(cfg)
    if not cfg.in_cnf():
        cfg.to_cnf()
        print('Transformed grammar to CNF:')
        print(cfg)
    print(cfg.cky(args.w))
