# This script demonstrates how to import the data into Python using pyarts
#
# Pyarts is installed by: conda install -c rttools pyarts
#
# See further: atmtools.github.io/arts-docs-master

import os

import pyarts.xml as xml

# You need to adjust the datafolder!
datafolder = '/home/patrick/Tmp/Yang2016/ArtsFormat'
habit = '5-PlateAggregate-Smooth'

# Load meta data
M = xml.load(
        os.path.join(datafolder, habit + '.meta.xml'),
        search_arts_path=False
    )

# As example, print diameter_max of first element
print(M[0].diameter_max)

# Load actual scattering data
S = xml.load(
        os.path.join(datafolder, habit + '.xml'),
        search_arts_path=False
    )

# For information about these data use help, as exemplifed below.
# See particularly the section "Data descriptors defined here:"

# help(type(M[0]))
# help(type(S[0]))
