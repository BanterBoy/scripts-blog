$XMLFilter = @'
<QueryList>
  <Query Id="0" Path="Application">
    <Select Path="Application">*[System[(Level=2 or Level=3) 
	  and TimeCreated[timediff(@SystemTime) &lt;= 86400000]]]</Select>
  </Query>
</QueryList>
'@
[array] $Events = @()
Get-WinEvent -ComputerName COMPUPTERNAME -FilterXml $XMLfilter
