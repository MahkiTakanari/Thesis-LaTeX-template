# ====================== Thesis/.latexmkrc ==============================
# 生成物の出力先（PDFや補助ファイルを out/ にまとめる）
$out_dir = "out";
$aux_dir = "out";

# ---- LaTeX 本体（uplatex） -------------------------------------------
# -kanji=utf8           : ソースは UTF-8 前提
# -no-guess-input-enc   : 文字コードの自動推測を無効化（誤判定防止）
# -synctex=1            : エディタ⇄PDF の同期用ファイルを出力
# -interaction=nonstopmode : エラーでも処理継続（ログに出す）
# -file-line-error      : エラーにファイル名と行番号を出す
$latex  = 'uplatex -kanji=utf8 -no-guess-input-enc -synctex=1 -interaction=nonstopmode -file-line-error %O %S';

# ---- DVI → PDF（dvipdfmx） -------------------------------------------
# %S: 入力 .dvi,  %D: 出力 .pdf
$dvipdf = 'dvipdfmx %O -o %D %S';

# pdf_mode=3 : DVI 経由（uplatex → DVI → PDF）を使う
$pdf_mode = 3;

# ---- biblatex / biber ------------------------------------------------
# 通常はこちらでOK（.bcf → .bbl を biber が生成）
$biber = 'biber %O %B';

# もし環境依存で文字化けする場合の代替（必要なときだけ有効化）
# $biber = 'biber %O --bblencoding=utf8 -u -U --output_safechars %B';

# ---- 参照の再解決（クロスリファレンスが収束するまでの最大リトライ回数）
$max_repeat = 5;

# ---- クリーン設定 ----------------------------------------------------
# 追加で生成されたファイルも full clean 対象に含める
$cleanup_includes_cusdep_generated = 1;

# （必要なら）拡張クリーン対象を明示追加
# $clean_full_ext = "%R.fdb_latexmk %R.fls %R.blg %R.bbl %R.run.xml";
