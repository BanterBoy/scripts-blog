function Test-DeathstarBackUp {
    Test-OpenPorts -ComputerName DEATHSTAR -Ports 80, 443, 445 # ,7878,8989,9117,49092
}