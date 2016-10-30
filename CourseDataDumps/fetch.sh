
## enable this to fetch the master list of webpages
#curl 'https://telaris.wlu.ca/ssb_prod/bwckschd.p_get_crse_unsec' -H 'Origin: https://telaris.wlu.ca' -H 'Accept-Encoding: gzip, deflate, br' -H 'Accept-Language: en-US,en;q=0.8' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: max-age=0' -H 'Referer: https://telaris.wlu.ca/ssb_prod/bwckgens.p_proc_term_date' -H 'Connection: keep-alive' --data 'term_in=201701&sel_subj=dummy&sel_day=dummy&sel_schd=dummy&sel_insm=dummy&sel_camp=dummy&sel_levl=dummy&sel_sess=dummy&sel_instr=dummy&sel_ptrm=dummy&sel_attr=dummy&sel_subj=AN&sel_subj=AB&sel_subj=AR&sel_subj=AS&sel_subj=BH&sel_subj=BI&sel_subj=BF&sel_subj=BU&sel_subj=MB&sel_subj=ART&sel_subj=DSG&sel_subj=DME&sel_subj=PRG&sel_subj=CH&sel_subj=CS&sel_subj=CMEG&sel_subj=CP&sel_subj=CC&sel_subj=CQ&sel_subj=KS&sel_subj=DH&sel_subj=EC&sel_subj=EU&sel_subj=EM&sel_subj=EN&sel_subj=ENTR&sel_subj=ES&sel_subj=FS&sel_subj=FR&sel_subj=DD&sel_subj=GG&sel_subj=GL&sel_subj=GM&sel_subj=GC&sel_subj=GV&sel_subj=GS&sel_subj=HE&sel_subj=HS&sel_subj=HI&sel_subj=HP&sel_subj=HN&sel_subj=HR&sel_subj=ID&sel_subj=UU&sel_subj=IP&sel_subj=IT&sel_subj=JN&sel_subj=KP&sel_subj=LL&sel_subj=LY&sel_subj=OL&sel_subj=MF&sel_subj=MS&sel_subj=MA&sel_subj=MX&sel_subj=ML&sel_subj=MI&sel_subj=MU&sel_subj=MZ&sel_subj=ED&sel_subj=NO&sel_subj=PP&sel_subj=PC&sel_subj=PD&sel_subj=PO&sel_subj=PS&sel_subj=RE&sel_subj=SNID&sel_subj=SC&sel_subj=SJ&sel_subj=SE&sel_subj=SK&sel_subj=CT&sel_subj=SY&sel_subj=SP&sel_subj=ST&sel_subj=TM&sel_subj=TH&sel_subj=36&sel_subj=AP&sel_subj=04&sel_subj=CX&sel_subj=05&sel_subj=MW&sel_subj=PM&sel_subj=20&sel_subj=WS&sel_subj=YC&sel_crse=&sel_title=&sel_camp=%25&sel_levl=%25&begin_hh=00&begin_mi=00&begin_ap=x&end_hh=00&end_mi=00&end_ap=x' --compressed > CourseList.html

htmlDumpLoc="courseDumps"

egrep -o '/ssb_prod/bwckctlg.p_display_courses\?term_in=.{1,10}&amp;one_subj=.{1,10}&amp;.{0,50}sel_crse_end=.{1,6}&amp;' CourseList.html > href.txt 
sed 's/sel_subj=&amp;//' href.txt > goodHref.txt
sed "s/\(amp;\)//g" goodHref.txt > href.txt
sed "s/&$/&sel_subj=&sel_levl=&sel_schd=&sel_coll=&sel_divs=&sel_dept=&sel_attr=/" href.txt > goodHref.txt
sed "s/^/https:\/\/telaris.wlu.ca/" goodHref.txt > href.txt

sort href.txt | uniq > goodHref.txt
cat goodHref.txt > href.txt
rm goodHref.txt


while read line; do
  subject="$line"
  courseCode="$line"
  subject="${subject##*one_subj=}"  # retain the part after the last slash
  subject="${subject%%&sel*}"  # retain the part before the colon
  courseCode="${courseCode##*sel_crse_strt=}"  # retain the part after the last slash
  courseCode="${courseCode%%&sel*}"  # retain the part before the colon
  
  ## enable this to fetch all webpages
  #curl "$line" > "$htmlDumpLoc/$subject$courseCode.html"

  sed '/<[Ss][Cc][Rr][Ii][Pp][Tt]/,/<\/[Ss][Cc][Rr][Ii][Pp][Tt]>/d' "$htmlDumpLoc/$subject$courseCode.html" > "${htmlDumpLoc}Clean/$subject$courseCode.html"
done <href.txt

rm href.txt



