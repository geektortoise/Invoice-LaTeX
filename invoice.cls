%By Renaud Hoyoux
\NeedsTeXFormat{LaTeX2e}

\ProvidesClass{invoice}[2017/09/13, V1.0]

%Parent
\LoadClass[a4paper]{article}

\RequirePackageWithOptions{babel}
\def\setLanguage{}
\DeclareOption{francais}{%\AtEndOfClass{\main@language{francais}}}
  \selectlanguage{french}%
  \def\setLanguage{francais}%
}
\DeclareOption{english}{%\AtEndOfClass{\main@language{english}}}
  \selectlanguage{english}%
  \def\setLanguage{english}%
}
\ProcessOptions

%%%%%%%%%%%%%%%%%%%%%%
% content definition %
%%%%%%%%%%%%%%%%%%%%%%

\pagestyle{empty}
\RequirePackage[a4paper, left=0cm, right=0cm, bottom=6cm, top=6cm, bindingoffset=1.5cm]{geometry}
\RequirePackage[table]{xcolor}
\RequirePackage{tcolorbox}
\RequirePackage{longtable}
\RequirePackage{fontspec}
\RequirePackage{fancyhdr}
\RequirePackage{tikz}
\usetikzlibrary{calc}
\usetikzlibrary{fpu}
\input pgfmath.tex


%%%%%%%%%%%%%%%%%%%%%
% color definitions %
%%%%%%%%%%%%%%%%%%%%%

\colorlet{totallinecolor}{gray!25}
\colorlet{tablecolor1}{gray!9}
\colorlet{tablecolor2}{gray!15}
\colorlet{footnotegray}{gray!90}
\definecolor{tortoise}{RGB}{101,196,49}



%%%%%%%%%%%%%%%%%%%%%
% private variables %
%  (only used for   %
% language switch)  %
%%%%%%%%%%%%%%%%%%%%%

\def\invoiceNumberLabel{}
\def\invoiceDateLabel{}
\def\invoiceMonthLabel{}
\def\totalDueLabel{}
\def\productDescriptionLabel{}
\def\unitPriceLabel{}
\def\quantityLabel{}
\def\priceLabel{}
\def\subtotalLabel{}
\def\vatLabel{}
\def\discountLabel{}
\def\totalLabel{}
\def\paymentTermsLabel{}
\def\invoiceLabel{}
\def\bankTransferLabel{}
\def\bankCommunicationLabel{}
\def\dueDateLabel{}
\def\thxMsg{}
\def\vatNumberLabel{}


\ifnum\pdfstrcmp{\setLanguage}{english}=0
  \def\invoiceNumberLabel{Invoice number}
  \def\invoiceDateLabel{Invoice date}
  \def\invoiceMonthLabel{Concerned month}
  \def\totalDueLabel{Total Due}
  \def\productDescriptionLabel{Product Description}
  \def\unitPriceLabel{Unit Price}
  \def\quantityLabel{Quantity}
  \def\priceLabel{Price}
  \def\subtotalLabel{Sub-total}
  \def\vatLabel{VAT}
  \def\discountLabel{Discount}
  \def\totalLabel{Total}
  \def\paymentTermsLabel{Payment Terms}
  \def\invoiceLabel{INVOICE}
  \def\bankTransferLabel{By bank transfer}
  \def\bankCommunicationLabel{Communication}
  \def\dueDateLabel{Payable within 30 days}
  \def\thxMsg{Thank you for your confidence}
  \def\vatNumberLabel{VAT number}
\fi
\ifnum\pdfstrcmp{\setLanguage}{francais}=0
  \def\invoiceNumberLabel{Numéro de facture}
  \def\invoiceDateLabel{Date de facturation}
  \def\invoiceMonthLabel{Mois de prestation}
  \def\totalDueLabel{Montant dû}
  \def\productDescriptionLabel{Description du produit}
  \def\unitPriceLabel{Prix unitaire}
  \def\quantityLabel{Quantité}
  \def\priceLabel{Prix}
  \def\subtotalLabel{Sous-total}
  \def\vatLabel{TVA}
  \def\discountLabel{Ristourne}
  \def\totalLabel{Total}
  \def\paymentTermsLabel{Moyen de payement}
  \def\invoiceLabel{FACTURE}
  \def\bankTransferLabel{Par virement}
  \def\bankCommunicationLabel{Communication}
  \def\dueDateLabel{Payable dans les 30 jours}
  \def\thxMsg{Merci de votre confiance}
  \def\vatNumberLabel{Numéro de TVA}
\fi



%%%%%%%%%%%%%%%%%%%%%
% redef variables   %
%%%%%%%%%%%%%%%%%%%%%

\def\vat{}
\def\discount{}
\def\invoiceNumber{}
\def\invoiceMonth{}
\def\client{}

%%%%%%%%%%%%%%%%%%%%%
%                   %
%%%%%%%%%%%%%%%%%%%%%

% footnote style
\def\footnotestyle#1{%
  {\textsf{\color{footnotegray}\fontsize{3mm}{0mm}\selectfont #1}}%
}

\newtcolorbox{headertcolorbox}[1][]{
  before={},
  enlarge bottom by=-0.5cm,
  sharp corners,
  rounded corners=northeast,
  rounded corners=southwest,
  arc=5mm,
  colback=tortoise,
  colframe=tortoise,
  coltext=white,
  left=0pt,
  right=0pt,
  #1
}
\newenvironment{headerbox}[1][]{\begin{headertcolorbox}[#1]\begin{center}\bfseries} {\end{center}\end{headertcolorbox}}

%%%%%%%%%%%%%%%%%%%%%
% tabular           %
%%%%%%%%%%%%%%%%%%%%%


\def\subtotalExpression{0}


\newcounter{cnt}
\newcommand\addinvoiceline[3]{%
  \stepcounter{cnt}%
  \expandafter\newcommand\csname ary1-\the\value{cnt} \endcsname{\unexpanded{#1}}
  \expandafter\newcommand\csname ary2-\the\value{cnt} \endcsname{\unexpanded{\pgfmathprintnumber[fixed,precision=0]{#2}}}
  \expandafter\newcommand\csname ary3-\the\value{cnt} \endcsname{\unexpanded{\pgfmathprintnumber[fixed,precision=0]{#3}}}
  \expandafter\newcommand\csname ary4-\the\value{cnt} \endcsname{\unexpanded{%
    \pgfkeys{/pgf/fpu}\pgfmathparse{#2*#3}\pgfmathprintnumber[fixed,precision=0]{\pgfmathresult}\pgfkeys{/pgf/fpu=false}%
  }}

  \edef\subtotalExpression{(\subtotalExpression) +  (#2 * #3)}
}

\newcounter{it}
\setcounter{it}{1}
\def\invoicelines{}

\long\def\addto#1#2{\expandafter\def\expandafter#1\expandafter{#1#2}}

\def\totalInvoice{}

\newcommand\generateinvoicelines{%
  \stepcounter{cnt}% to have the last line

  \loop
    \edef\tabline{\csname ary1-\the\value{it} \endcsname & \csname ary2-\the\value{it} \endcsname & \csname ary3-\the\value{it} \endcsname &  \csname ary4-\the\value{it} \endcsname €}

    \expandafter\addto\expandafter\invoicelines\expandafter{\tabline \\}

    \addtocounter{it}{1}
    \ifnum \theit<\thecnt
  \repeat 

  \pgfkeys{/pgf/fpu}
    \pgfmathsetmacro{\totalInvoice}{(\subtotalExpression) * (1 + (\vat / 100)) * (1-(\discount / 100))}
  \pgfkeys{/pgf/fpu=false}
}


\def\totalInvoiceLine{
  \rowcolor{totallinecolor}
  \cellcolor{white} & \cellcolor{white} & \subtotalLabel & \pgfkeys{/pgf/fpu} \pgfmathparse{\subtotalExpression} \pgfmathprintnumber[fixed,zerofill,precision=2]{\pgfmathresult} € \pgfkeys{/pgf/fpu=false}\\
  \rowcolor{totallinecolor}
  \cellcolor{white} & \cellcolor{white} & \vatLabel & \pgfmathprintnumber[fixed,precision=0]{\vat} \% \\
  \rowcolor{totallinecolor}
  \expandafter\ifnum\discount>0 \cellcolor{white} & \cellcolor{white} & \discountLabel & \pgfmathprintnumber[fixed,precision=0]{\discount} \%  \\ \fi
  \rowcolor{totallinecolor}
  \cellcolor{white} & \cellcolor{white} & \totalLabel & \pgfkeys{/pgf/fpu}\pgfmathparse{(\subtotalExpression) * (1 + (\vat / 100)) * (1-(\discount / 100))} \pgfmathprintnumber[fixed,precision=2]{\pgfmathresult} € \pgfkeys{/pgf/fpu=false}
}


\newcommand\maketabular{%
  \generateinvoicelines

  \setlength\LTleft{-0.51in}
  \newcolumntype{C}{>{\hspace{0.75em}\centering\arraybackslash}p{.45\textwidth}}
  \newcolumntype{x}{>{\centering\arraybackslash}p{.2\textwidth}}
  \newcolumntype{X}{>{\centering\arraybackslash}p{.15\textwidth}}
  \newcolumntype{R}{>{\raggedleft\arraybackslash}p{.2\textwidth}}
  \renewcommand*{\arraystretch}{2}
  \colorlet{footnotegray}{gray!90}

  \rowcolors{3}{tablecolor1}{tablecolor2}
  \begin{longtable}{@{\extracolsep{\fill}}C x X x}
     & & %
    \ifnum\pdfstrcmp{\setLanguage}{english}=0
      \def\widthTotal{3.2cm}
      \def\offsetLeft{-0.5cm}
    \fi
    \ifnum\pdfstrcmp{\setLanguage}{francais}=0
      \def\widthTotal{3.6cm}
      \def\offsetLeft{-1cm}
    \fi
    \begin{tcolorbox}[before={},enlarge bottom by=-0.5cm,enlarge left by=\offsetLeft,sharp corners, rounded corners=northeast, rounded corners=southwest, arc=5mm, colback=black, colframe=black,coltext=white,width=\widthTotal]%
      \begin{center}\bfseries\large \totalDueLabel\end{center}%
    \end{tcolorbox}%
 & %
    \begin{tcolorbox}[before={},enlarge bottom by=-0.5cm,sharp corners, rounded corners=northeast, rounded corners=southwest, arc=5mm, colback=black, colframe=black,coltext=white]%
      \begin{center}\bfseries\Large \pgfmathprintnumber[fixed,precision=2]{\totalInvoice} €\end{center}%
    \end{tcolorbox}%
\\
    \begin{headerbox}[width=.4\textwidth, enlarge left by=0.5cm]%
      \productDescriptionLabel%
    \end{headerbox}%
 & %
    \begin{headerbox}
      \unitPriceLabel%
    \end{headerbox}%
 & %
    \begin{headerbox}
      \quantityLabel%
    \end{headerbox}%
 & %
    \begin{headerbox}
      \priceLabel%
    \end{headerbox}%
\\
    \endhead
    \endfoot
    \invoicelines
    \totalInvoiceLine
  \end{longtable}
}


%%%%%%%%%%%%%%%%%%%%%
% header & footer   %
%%%%%%%%%%%%%%%%%%%%%

\renewcommand{\headrulewidth}{0pt}

\pagestyle{fancy}
\fancyhf{}
\fancyhead[C]{%
  \begin{tikzpicture}[overlay, remember picture]%
    \fill[tortoise] (current page.north west)+(0,-.33in) rectangle ($(current page.north east)-(0,.39in)$);
    \node[anchor=south] at ($(current page.north)-(0,1in)$) {\includegraphics[height=3cm]{images/logo}};%
    \node[anchor=south] at ($(current page.north)+(2.5in,-.6in)$) {%
      \begin{tcolorbox}[sharp corners, rounded corners=northeast, rounded corners=southwest, arc=5mm, colback=black, colframe=black,coltext=white,width=3.5cm]%
        \begin{center}\bfseries \invoiceLabel\end{center}%
      \end{tcolorbox}%
    };%
    \node[anchor=south] at ($(current page.north)+(2.7in,-1.3in)$) {%
      \begin{minipage}[t]{0.35\textwidth}%
        \vbox{%
          \invoiceNumberLabel : \invoiceNumber  \\
          \invoiceDateLabel : \ \today \\
          \invoiceMonthLabel : \invoiceMonth
        }%
      \end{minipage}%
    };%
    \node[anchor=south] at ($(current page.north)+(2in,-2.2in)$) {%
      \begin{minipage}[t]{0.35\textwidth}%
      \vbox{\textbf{%
        \client
      }}%
      \end{minipage}%
    };%
    \node[anchor=south] at ($(current page.north west)+(2in,-2in)$) {%
      \begin{minipage}[t]{0.35\textwidth}%
      \vbox{%
        Renaud Hoyoux  \\
        my street,\\
        my city\\
        my phone\\
        my email
      }%
      \end{minipage}%
    };%
  \end{tikzpicture}%
}

\fancyfoot[C]{
  \begin{tikzpicture}[overlay, remember picture]%
    \node[anchor=south east, text=tortoise, font=\LARGE, minimum size=.5in, inner xsep=5mm] at ($(current page.south east)+(0,.5in)$) {\emph{\thxMsg}};
    \node[anchor=south west, minimum size=.5in] at ($(current page.south west)+(0,1in)$) {%
      \begin{minipage}[t]{0.6\textwidth}%
        \begin{center}\begin{tcolorbox}[sharp corners, rounded corners=northeast, rounded corners=southwest, arc=5mm, colback=black, colframe=black,coltext=white,width=7cm]%
          \begin{center}\large\bfseries \paymentTermsLabel\end{center}%
        \end{tcolorbox}\end{center}%
        \hspace{3cm}\vbox{\bankTransferLabel : \emph{IBAN xxxx.xxxx.xxxx}\\
        \bankCommunicationLabel : \emph{\invoiceNumber}\\
        \dueDateLabel.}
      \end{minipage}%
    };
    \fill[tortoise] (current page.south west) rectangle ($(current page.south east)+(0,.5in)$);
    \node[anchor=south west, text=white, font=\large, minimum size=.5in, inner xsep=5mm] at (current page.south west) {\vatNumberLabel : xx.xx.xx.xx};
    \node[anchor=south, text=white, font=\Large, minimum size=.5in] at (current page.south) {Renaud Hoyoux};
    \node[anchor=south east, text=white, font=\large, minimum size=.5in, inner xsep=5mm] at (current page.south east) {www.geektortoise.be};
  \end{tikzpicture}
}

