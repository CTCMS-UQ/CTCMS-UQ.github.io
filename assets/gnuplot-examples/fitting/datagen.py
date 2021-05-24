#!/usr/bin/python3
import numpy as np
from numpy.random import default_rng
def random_line(xs, a, b):
    """ Generate a point from the line y = a*x + b, displaced by some small random value. """
    rng = default_rng()
    r = rng.normal(0, 0.25, size=len(xs))
    return((a+r)*xs + b + r)

def random_sin(xs, a, b):
    """ Generate a point from the curve y = sin(a*x + b), displaced by some small random value. """
    rng = default_rng()
    r = rng.normal(0, 0.25, size=len(xs))
    return(np.sin((a+r)*xs + b + r))

if __name__ == "__main__":
    
    xs = np.linspace(-np.pi, np.pi, 15)
    ys = random_sin(xs, 2, 0.25)

    for x,y in zip(xs, ys):
        print(f"{x}  {y}")
