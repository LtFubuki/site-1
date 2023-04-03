```bash
docker-compose up -d
```


```bash
./check_for_updates.sh > check_updates.log 2>&1 &
```


This command will redirect both the standard output (stdout) and the standard error (stderr) to a log file named check_updates.log. The & at the end of the command tells the shell to run the script in the background.

You can check if the script is running in the background by using the jobs command:

```bash
jobs
```


To bring the background process back to the foreground, you can use the fg command:

```bash
fg %1
```

Replace %1 with the job number displayed by the jobs command.

If you want to view the logs while the script is running in the background, you can use the tail command:

```bash
tail -f check_updates.log
```

This command will continuously display the contents of the log file as it updates. To stop viewing the logs, press Ctrl + C.
