#!/bin/bash

awk 'NR%4==1' $1 > $2
