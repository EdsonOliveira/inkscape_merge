# AddOn to inkscape_merge
# my version in portuguese Brazil pt_BR

# Configure to run --------
dir_temp="./miolos/"
SvgEsq="ModeloEsquerdo.svg"
SvgDir="ModeloDireito.svg"
CsvArqDir="Janeiro.dir.csv"
CsvArqEsq="Janeiro.esq.csv"
# -------------------------------

# local variable
direito=0
esquerda=0
arqdir="d-%d.pdf"
pdfdir="d-*.pdf"
arqesq="e-%d.pdf"
pdfesq="e-*.pdf"

echo
#echo "Gerando mistura de SVG com tabela"
echo "Generating merge SVG-CSV to pages Right ens Left sides"
echo
#echo "Gerando páginas"
echo "Generating Pages"
echo
#echo "-- Paginas direitas"
echo "Generatind right side"
inkscape_merge -f $SvgDir -d $CsvArqDir -o $dir_temp$arqdir
# ckeck how many right pages did you have
# verifica quantos direita tem
vearq="$dir_temp""$pdfdir"
for i in $vearq ; do 
  [[ -f "$i" ]] || continue
  ((direita++))
done
#echo "Geradas [ $direita ] páginas direitas"
echo "[ $direita ] right pages created"
echo
#echo "-- Paginas esquerdas"
echo "Generatind left side"
inkscape_merge -f $SvgEsq -d $CsvArqEsq -o $dir_temp$arqesq
echo
#---------------------------------------------
# ckeck how many left pages did you have
# verifica quantos esquerda tem
vearq="$dir_temp""$pdfesq"
for i in $vearq ; do 
  [[ -f "$i" ]] || continue
  ((esquerda++))
done
#echo "Geradas [ $esquerda ] páginas esquerdas"
echo "[ $direita ] left pages created"
echo
#echo "Testando número de páginas"
echo "Testing if have legal number of pages"
# if left > right or right-left if greater 1 we have an error
# testa erro para esquerda>direita e ( esquerda#direita > 1)
# Resultados
#   esq > dir = erro
#   dir - esq >1 erro
difere=$(( direita - esquerda ))
if [ $esquerda -gt $direita ]
then
#   echo "ERRO - mais páginas esquerdas"
#   echo "       Revisar as tabelas"
   echo "ERROR - More pages of left than allowed"
   echo "        Recreate .csv"
   exit
elif [ $difere -gt 1 ]
then
#   echo "ERRO - mais de uma página direita de diferença"
#   echo "       Revisar as tabelas"
   echo "ERROR - More pages of right than allowed"
   echo "        Recreate .csv"
   exit
fi
#echo "Número de páginas aceitas"
#echo "Geradas [ $direita ] páginas direitas"
#echo "Geradas [ $esquerda ] páginas esquerdas"
echo "number of pages are ok"
echo "Generated [ $direita ] right side pages"
echo "Generated [ $esquerda ] leff side pages"
echo
#echo "renomeando as páginas"
echo "rename all pages"
echo

i=0
j=0
while [[ $i -lt $direita ]] ; do
  (( i += 1 ))
  vazio=""
  if [ -f "$dir_temp""d-$i.pdf" ]; then
    (( j += 1 ))
    nomant="$dir_temp""d-$i.pdf"
    if [ $j -le 9 ]
    then
      nonew="$dir_temp""x-0$j.pdf"
    else
      nonew="$dir_temp""x-$j.pdf"
    fi
    mv $nomant $nonew
    echo "$j - $nomant $nonew" 
  fi
  if [ -f "$dir_temp""e-$i.pdf" ]; then
    (( j += 1 ))
    nomant="$dir_temp""e-$i.pdf"
    if [ $j -le 9 ]
    then
      nonew="$dir_temp""x-0$j.pdf"
    else
      nonew="$dir_temp""x-$j.pdf"
    fi
    mv $nomant $nonew
    echo "$j - $nomant $nonew" 
  fi
done
echo
#echo "Gerando arquivo final agrupado"
echo "Creating final file with pdftk"
pdftk $dir_temp*.pdf cat output Mesclado.pdf
echo
rm -f -r $dir_temp
ls Mesclado.pdf
echo
#echo Pronto
echo "all right"
echo "Done!"
