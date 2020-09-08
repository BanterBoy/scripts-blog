$Session = New-Object -ComObject "Microsoft.Update.Session"
$Searcher = $Session.CreateUpdateSearcher()
$historyCount = $Searcher.GetTotalHistoryCount()

$Searcher.QueryHistory(0, $historyCount) | Select-Object Title,Description,Date,@{name="Operation"; expression={switch($_.operation){
        1 {"Installation"}; 2 {"Uninstallation"}; 3 {"Other"}
		}
	}
} | Format-List -Property *
