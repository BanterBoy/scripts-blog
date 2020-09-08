$head = '<style>
 BODY{font-family:Verdana; background-color:lightblue;}
 TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
 TH{font-size:1.3em; border-width: 1px;padding: 2px;border-style: solid;border-color: black;background-color:#FFCCCC}
 TD{border-width: 1px;padding: 2px;border-style: solid;border-color: black;background-color:yellow}
</style>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js"></script>
<script type="text/javascript">
 $(function(){
  var linhas = $("table tr");
  $(linhas).each(function(){
   var Valor = $(this).find("td:first").html();
   if(Valor == "Stopped"){
    $(this).find("td").css("background-color","Red");
   }else if(Valor == "Running"){
    $(this).find("td").css("background-color","Green");
   }
  });
 });
</script>
'
$header = "<H1>Reporting Service Status</H1>"
$title = "Example HTML Output"

Get-Service |
  Select-Object Status, Name, DisplayName |
  ConvertTo-HTML -head $head -body $header -title $title |
  Out-File $env:temp\report.hta
Invoke-Item $env:temp\report.hta

