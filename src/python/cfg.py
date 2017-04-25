#! /usr/bin/python
# -*- coding: utf-8 -*-

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import os

class CFG:
    """A class that models a context-free grammar.
    Parameters:
    :N: list of non-terminals
    :V: list of terminals
    :P: dictionary of productions
    :S: initial symbol
    """

    def __init__(self, terminals=None, non_terminals=None, initial_symbol=None, productions=None, epsilon='!'):
        # check that terminals and non_terminals are disjoint
        if terminals is not None and non_terminals is not None:
            assert set(terminals).isdisjoint(set(non_terminals))

        # check that the initial symbol is in the set of non-terminals
        if initial_symbol is not None and non_terminals is not None:
            assert initial_symbol in non_terminals

        self.V = set(terminals) if terminals is not None else None
        self.N = set(non_terminals) if non_terminals is not None else None
        self.P = productions
        self.S = initial_symbol
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

    def parse_classic(self, filepath='grammar.cfg'):
        pass

    def parse_waterloo(self, filepath='grammar.cfg'):
        """Parses a grammar in 'waterloo' format. See [https://www.student.cs.uwaterloo.ca/~cs241/cfg/cfg.html], and
        [../README.md](the readme) for more info.
        """
        with open(filepath, 'r') as f:
            state = 0
            for line in f:
                cont = line.strip()
                if state == 0:
                    t = int(cont)
                    assert t >= 0
                    state = 1 if t > 0 else 2
                elif state == 1:
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
                    assert rhs != []
                    if self.P is None:
                        self.P = {lhs: [rhs]}
                    else:
                        try:
                            self.P[lhs].append(rhs)
                        except KeyError:
                            self.P[lhs] = [rhs]
                    r -= 1
                    if r == 0:
                        break
        self.V = set(self.V)
        self.N = set(self.N)

    def parse_from_file(self, form='waterloo', filepath='grammar.cfg'):
        """Calls a parser to read a grammar from filepath, according to the given format
        """
        assert form in ['waterloo', 'classic']
        assert os.path.exists(filepath)
        if form == 'waterloo':
            self.parse_waterloo(filepath)
        else:
            self.parse_classic(filepath)

    def remove_epsilons(self):
        assert self.P is not None

        # identify non-terminals with epsilon productions
        epsilon_nts = []
        for head, bodies in self.P.items():
            for body in bodies:
                if body == [self.epsilon]:
                    epsilon_nts.append(head)

        # add new productions
        new_prods = {}
        for ep in epsilon_nts:
            for head, bodies in self.P.items():
                for body in bodies:
                    for i, sym in enumerate(body):
                        if ep == sym:
                            try:
                                new_prods[head].append(body[:i-1] + body[i:])
                            except KeyError:
                                new_prods[head] = [body[:i] + body[i+1:]]
        for np, bs in new_prods.items():
            self.P[np] += bs

        # delete epsilon productions
        for ep in epsilon_nts:
            self.P[ep] = list(filter(lambda a: a != [self.epsilon], self.P[ep]))


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
    cfg = CFG()
    cfg.parse_from_file()
    print(cfg)
    # print(cfg.in_cnf())
    cfg.remove_epsilons()
    print(cfg)
