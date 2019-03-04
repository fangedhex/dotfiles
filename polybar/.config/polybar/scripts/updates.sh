#!/bin/sh
echo "" $(yay -Qu 2>/dev/null | wc -l) "/" $(yay -Q | wc -l)
