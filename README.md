![Python-for-Data-Sc](https://user-images.githubusercontent.com/52716203/87849606-d1b94c00-c8e1-11ea-9854-a8fc962dff1f.jpg)

<p align="center">
  <a href="https://github.com/yezz123">
    <img src="https://img.shields.io/github/followers/yezz123?label=Follow&style=social">
  </a>

## • Overview
Features of ML include a call-by-value evaluation strategy, first-class functions, automatic memory management through garbage collection, parametric polymorphism, static typing, type inference, algebraic data types, pattern matching, and exception handling. ML uses static scoping rules.

ML can be referred to as an impure functional language, because although it encourages functional programming, it does allow side-effects (like languages such as Lisp, but unlike a purely functional language such as Haskell). Like most programming languages, ML uses eager evaluation, meaning that all subexpressions are always evaluated, though lazy evaluation can be achieved through the use of closures. Thus one can create and use infinite streams as in Haskell, but their expression is indirect.

ML's strengths are mostly applied in language design and manipulation (compilers, analyzers, theorem provers), but it is a general-purpose language also used in bioinformatics, and financial systems.

ML was developed by Robin Milner and others in the early 1970s at the University of Edinburgh, whose syntax is inspired by ISWIM. Historically, ML was conceived to develop proof tactics in the LCF theorem prover (whose language, pplambda, a combination of the first-order predicate calculus and the simply-typed polymorphic lambda calculus, had ML as its metalanguage).

Today there are several languages in the ML family; the three most prominent are Standard ML (SML), OCaml and F#. Ideas from ML have influenced numerous other languages, like Haskell, Cyclone, Nemerle, ATS,[citation needed] and Elm.

## • Mathematics
Python has the usual symbols for arithmetic operators (+, -, *, /), the floor division operator // and the remainder operator % (where the remainder can be negative, e.g. 4 % -3 == -2). It also has ** for exponentiation, e.g. 5**3 == 125 and 9**0.5 == 3.0, and a matrix multiply operator @ . These operators work like in traditional math; with the same precedence rules, the operators infix ( + and - can also be unary to represent positive and negative numbers respectively).

Division between integers produces floating point results. The behavior of division has changed significantly over time:

Python 2.1 and earlier used C's division behavior. The / operator is integer division if both operands are integers, and floating-point division otherwise. Integer division rounds towards 0, e.g. 7/3 == 2 and -7/3 == -2.
Python 2.2 changed integer division to round towards negative infinity, e.g. 7/3 == 2 and -7/3 == -3. The floor division // operator was introduced. So 7//3 == 2, -7//3 == -3, 7.5//3 == 2.0 and -7.5//3 == -3.0. Adding from __future__ import division causes a module to use Python 3.0 rules for division (see next).
Python 3.0 changed / to always be floating-point division, e.g. 5/2 == 2.5.
In Python terms, / is true division (or simply division), and // is floor division. / before version 3.0 is classic division.

Rounding towards negative infinity, though different from most languages, adds consistency. For instance, it means that the equation (a + b)//b == a//b + 1 is always true. It also means that the equation b*(a//b) + a%b == a is valid for both positive and negative values of a. However, maintaining the validity of this equation means that while the result of a%b is, as expected, in the half-open interval [0, b), where b is a positive integer, it has to lie in the interval (b, 0] when b is negative.

Python provides a round function for rounding a float to the nearest integer. For tie-breaking, Python 3 uses round to even: round(1.5) and round(2.5) both produce 2. Versions before 3 used round-away-from-zero: round(0.5) is 1.0, round(-0.5) is −1.0.

Python allows boolean expressions with multiple equality relations in a manner that is consistent with general use in mathematics. For example, the expression a < b < c tests whether a is less than b and b is less than c. C-derived languages interpret this expression differently: in C, the expression would first evaluate a < b, resulting in 0 or 1, and that result would then be compared with c.

Python uses arbitrary-precision arithmetic for all integer operations. The Decimal type/class in the decimal module provides decimal floating point numbers to a pre-defined arbitrary precision and several rounding modes. The Fraction class in the fractions module provides arbitrary precision for rational numbers.

Due to Python's extensive mathematics library, and the third-party library NumPy that further extends the native capabilities, it is frequently used as a scientific scripting language to aid in problems such as numerical data processing and manipulation.

## • Notice
All codes written using python language in both of folder ML and Math.

be Nice with codes and donate me if that possible. ✌

And help me in issues. 👼

## • License
    Apache License
                           Version 2.0, January 2004
                        http://www.apache.org/licenses/

   TERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION
   
https://github.com/yezz123/ML/blob/master/LICENSE

<p align="center">
  Follow Me On
</p>
<p align="center">
  <a href="https://www.youtube.com/channel/UC5ba_E8pgMV0ETCRn7PQzUg?view_as=subscriber">
    <img src="https://www.iconsdb.com/icons/preview/black/youtube-4-xxl.png" width="40" height="40">
  </a>
  <a href="https://instagram.com/froggy__19">
    <img src="http://clipart-library.com/images_k/instagram-png-transparent/instagram-png-transparent-16.png" width="40" height="40">
    </a>
</p>
<p align="center"> <a href="https://www.buymeacoffee.com/tahiri" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/lato-orange.png" alt="Buy Me A Coffee" style="height: 51px !important;width: 217px !important;" ></a> <p>

