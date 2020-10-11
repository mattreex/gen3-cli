# TL;DR

The [gen3-cli](./README.md) bash scripts simplify interations with gen3 commons.

## installation

Install the gen3 scripts on a system like this:

* git clone
* add the following block to your ~/.bashrc script

```
export GEN3_CLI_HOME=~/"Path/To/gen3-cli"
if [ -f "${GEN3_CLI_HOME}/gen3/gen3setup.sh" ]; then
  source "${GEN3_CLI_HOME}/gen3/gen3setup.sh"
fi

```


## gen3 cli

gen3 [flags] command [command options]

### global flags

gen3 [flags] command

* --dryrun
* --verbose

```
ex:$ gen3 --dryrun pfb
```

### gen3 help

Show this README.
You can also run `gen3 COMMAND help` for most commands:

```
ex: $ gen3 pfb help
```


### gen3 status

List the variables associated with the current gen3 workspace - ex:

```
$ gen3 status
GEN3_CLI_HOME=/home/reuben/Code/PlanX/gen3-cli
```


### gen3 cd [home|workspace]

```
ex:$ gen3 cd workspace
ex:$ gen3 cd home
ex:$ gen3 cd  # defaults to workspace
```

This is just a little shortcut to 'cd' the shell to $GEN3_CLI_HOME

Note: defaults to *workspace* if not *home*
