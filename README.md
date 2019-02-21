To continually submit a test:
```bash
python test_submit.py -p ncrc3.intel17,ncrc3.intel18 -t repro-openmp-slurm,prod-openmp-slurm -r basic -e c96L33_am4p0
```
You should include -p platforms , -t targets, and -e experiments.  There should all be comma-separated lists.  The script will parse out the rest.  It will run until you kill it.  The way I do it is to background the script (ctrl+z) and then 
```bash
kill PID
```
Where PID is the process ID.
