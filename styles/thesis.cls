% =====================================================================
% styles/thesis.cls  （jsbookベースの修士論文クラス）
% 目的：
%  - 章・節の体裁、ヘッダ/フッタ、余白、キャプション、前付/後付の挙動を統一
% 前提：
%  - コンパイルは uplatex + dvipdfmx（hyperref と整合）
%  - 参考文献は biblatex（backend=biber）
% 初心者向けTIPS：
%  - 細部の数値（余白・ヘッダ高さ）は環境差で微調整が必要になることがあります
% =====================================================================
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{styles/thesis}[2025/10/16 v1.0 MamiLab thesis class (jsbook base)]

% ---- 親クラス（jsbook）へオプション受け渡し ----
% main.texで指定した \documentclass[twoside,openright]{styles/thesis} オブションをベースのjsbookに渡す
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{jsbook}}
\ProcessOptions\relax


% ---- ベースクラス読込 ------------------------------------------------------
% a4j: 用紙はA4（和文）
% 12pt: 本文サイズ
% uplatex: upLaTeXエンジン前提
% dvipdfmx: ドライバ（hyperrefや画像周りの互換性のため重要）
\LoadClass[a4j,12pt,uplatex,dvipdfmx]{jsbook}

% ---- 共通パッケージ（このプロジェクトで使う標準セット）------------------
% 図表・数式・和文拡張などを thesis-packages.sty に集約して読み込む。
\RequirePackage{styles/thesis-packages}


% ---- キャプション（図表タイトル）の体裁 -----------------------------------
\RequirePackage{caption}
\captionsetup{
  % labelsep=quad は「Fig. 1 ␣␣␣␣」のようにラベルと本文の間を広めに
  % 細かく詰めたい場合は labelsep=space に変更
  labelsep=quad,
}
% 図・表のラベル名を英語化（Fig., Table）
\captionsetup[figure]{name=Fig.~}    % 「図」→「Fig.」
\captionsetup[table]{name=Table~}    % 「表」→「Table」

% ---- 余白（geometry） ------------------------------------------------------
% プリンタや dvi→pdf 変換で微差が出るため、heightrounded で高さを丸める。
% \geometry{showframe} を有効にすると枠が表示され、調整しやすいです。
\RequirePackage[dvipdfmx]{geometry}
\setlength{\headheight}{16pt} % ヘッダ高さ（fancyhdrで必須。13〜16ptあたり）
\setlength{\headsep}{6mm}     % ヘッダ下端〜本文上端の距離（見栄えで調整）
% \geometry{showframe} % ← デバッグ時に余白枠を可視化したいとき一時的に使用
\geometry{
  top=26mm,     % 上余白
  bottom=25mm,  % 下余白
  inner=20mm,   % 綴じしろ
  outer=20mm,   % 小口
  heightrounded
}


% ---- ページスタイル（ヘッダ/フッタ）---------------------------------------
\RequirePackage{fancyhdr}
\pagestyle{fancy}

\fancyhead{} % 既定ヘッダを一旦クリア
% 章・節の見出しをヘッダに出す（和文表示）
\renewcommand{\chaptermark}[1]{\markboth{第\ \thechapter\ 章\,\, #1}{}}
\renewcommand{\sectionmark}[1]{\markright{\thesection\ ~#1}}
% 偶数（左ページ）は左ヘッダに章、奇数（右ページ）は右ヘッダに節を表示
\fancyhead[RO]{\rightmark}
\fancyhead[LE]{\leftmark}
\renewcommand{\headrulewidth}{0.3pt} % ヘッダ下の罫線

\fancyfoot{} % フッタも一旦クリア
\fancyfoot[C]{- \thepage\ -} % ページ下中央に「- 1 -」のように表示
\setlength{\headheight}{16pt} % 再掲：環境差でWarningが出る場合は微調整
\setlength{\footskip}{20pt}   % 本文下端〜フッタの距離


% 章頭（plainスタイル）の体裁：罫線なし・ページ番号のみ
\fancypagestyle{plain}{%
  \fancyhf{}%
  \fancyfoot[C]{- \thepage\ -}%
  \renewcommand{\headrulewidth}{0pt}%
  \renewcommand{\footrulewidth}{0pt}%
}

% 後付（backmatter）専用のページスタイル：全ページでヘッダ罫線なし
\fancypagestyle{backmatter}{%
  \fancyhf{}%
  % ヘッダは空のまま、フッタにページ番号だけ
  \fancyfoot[C]{- \thepage\ -}
  \renewcommand{\headrulewidth}{0pt}%
  \renewcommand{\footrulewidth}{0pt}%
}


\makeatletter
% ---- 付録に入ったらヘッダ表示を「付録A タイトル」の形に変更 ----------
\g@addto@macro\appendix{%
  \renewcommand{\chaptermark}[1]{%
    \markboth{付録\thechapter\ ~#1}{}%
  }%
}

% ---- 現在の plain スタイルを退避（のちほど戻すため） --------------------
\let\Thesis@plain@saved\ps@plain

% ---- \chapter の再定義（章頭ページの制御） -------------------------------
% ・openright オプション時は右ページ始まり（\cleardoublepage）
% ・章頭ページは plain スタイル（上で罫線なし・ページ番号のみ）
% ・章頭に図表が来ないよう \@topnum=0（上部に浮動体を置かない）
\renewcommand{\chapter}{%
  \if@openright\cleardoublepage\else\clearpage\fi
  \thispagestyle{plain}
  \global\@topnum\z@
  \secdef\@chapter\@schapter}



% ---- 前付（frontmatter） -------------------------------------------
% ・ページ番号非表示
% ・plain スタイルも empty に置き換え → 目次最初のページにも番号を出さない
\renewcommand{\frontmatter}{%
  \cleardoublepage
  \pagestyle{empty}%：ページ番号非表示
  \let\ps@plain\ps@empty       % ← 目次などの章頭でページ番号を出さない
}

% ---- 本文（mainmatter） --------------------------------------------
% ・アラビア数字のページ番号に切替
% ・plain スタイルを章頭用の既定に戻す
\renewcommand{\mainmatter}{%
  \cleardoublepage
  \@mainmattertrue
  \pagenumbering{arabic}
  \pagestyle{fancy}%
  \let\ps@plain\Thesis@plain@saved
}

% ---- 後付（backmatter）--------------------------------------------
% ・参考文献・謝辞などは backmatter ページスタイル（ヘッダ罫線なし）
\renewcommand{\backmatter}{%
  \cleardoublepage
  \pagestyle{backmatter}%
}

\makeatother


% ---- 目次・番号付けの深さ -------------------------------------------------
% secnumdepth: 見出しに番号を振る深さ（2= subsectionまで）
% tocdepth   : 目次に載せる深さ（2= subsectionまで）
% 章・節・小節までに統一。必要なら 3(subsubsection) へ変更可。
\setcounter{secnumdepth}{2}
\setcounter{tocdepth}{2}