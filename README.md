# Invoice-LaTeX
My LaTeX template for generating invoices.

## How to use it
- Clone this repository
- Compile the example files with XeTeX.

### How do I run XeTeX ?
I run XeTex with the following command line (Linux) : `xelatex example.tex`

### Requirements
Here is a latex installation guide to run XeTex with the needed dependencies so you can add the missing parts :
```
apt-get update -y 
apt-get -y install software-properties-common
add-apt-repository ppa:jonathonf/texlive-2016 && \
apt-get update -y && apt-get -y install \
		texlive \
		texlive-xetex \
		texlive-fonts-extra \
		nano \
		texlive-lang-french
```
