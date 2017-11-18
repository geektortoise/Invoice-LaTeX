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
		texlive-lang-french
```

### Your name is still into the cls and not into an external variable !
Yep !  
The name and adress of the user of this template will not change often compare to its clients.  
So I didn't want to have useless lines like "Myself, my adress, ..." into each of my tex files.  
I'm lazy, that's the spirit.

If you want to use this template for your invoices, you just need to update these values into the cls file.
