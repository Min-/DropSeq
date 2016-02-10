#!/bin/bash

awk 'NR%4==2' $1 > $2
