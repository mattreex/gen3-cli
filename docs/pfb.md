## Usage

### Main

    Usage: gen3 pfb [OPTIONS] COMMAND [ARGS]...

      PFB: Portable Format for Biomedical Data.

    Commands:
      add     Add records into a PFB file.
      from    Generate PFB from other data formats.
      make    Make a blank record for add.
      rename  Rename different parts of schema.
      show    Show different parts of a PFB file.
      to      Convert PFB into other data formats.

### Show different parts of PFB

    Usage: gen3 pfb show [OPTIONS] COMMAND [ARGS]...

      Show records of the PFB file.

      Specify a sub-command to show other information.

    Options:
      -i, --input FILENAME  The PFB file.  [default: <stdin>]
      -n, --limit INTEGER   How many records to show, ignored for sub-commands.
                            [default: no limit]

    Commands:
      metadata  Show the metadata of the PFB file.
      nodes     Show all the node names in the PFB file.
      schema    Show the schema of the PFB file.

    Examples:
      schema:
        gen3 pfb show -i data.avro schema
      nodes:
        gen3 pfb show -i data.avro nodes
      metadata:
        gen3 pfb show -i data.avro metadata
      records:
        gen3 pfb show -i data.avro -n 5

### Convert Gen3 data dictionary into PFB schema

    Usage: gen3 pfb from [PARENT OPTIONS] dict DICTIONARY

      Convert Gen3 data DICTIONARY into a PFB file.

      If DICTIONARY is a HTTP URL, it will be downloaded and parsed as JSON; or
      it will be treated as a local path to a directory containing YAML files.

    Parent Options:
      -o, --output FILENAME  The output PFB file.  [default: <stdout>]

    Examples:
      URL:
        gen3 pfb from -o thing.avro dict https://s3.amazonaws.com/dictionary-artifacts/gtexdictionary/3.2.2/schema.json
      Directory:
        gen3 pfb from -o gdc.avro dict /path/to/dictionary/schemas/

### Convert JSON for corresponding datadictionary to PFB

    Usage: gen3 pfb from [PARENT OPTIONS] json [OPTIONS] [PATH]

      Convert JSON files under PATH into a PFB file.

    Parent Options:
      -o, --output FILENAME  The output PFB file.  [default: <stdout>]

    Options:
      -s, --schema FILENAME  The PFB file to load the schema from.  [required]
      --program TEXT         Name of the program.  [required]
      --project TEXT         Name of the project.  [required]

    Example:
      gen3 pfb from -o data.avro json -s schema.avro --program DEV --project test /path/to/data/json/

### Convert TSV for corresponding datadictionary to PFB

    Usage: gen3 pfb from [PARENT OPTIONS] tsv [OPTIONS] [PATH]

      Convert TSV files under PATH into a PFB file.

    Parent Options:
      -o, --output FILENAME  The output PFB file.  [default: <stdout>]

    Options:
      -s, --schema FILENAME  The PFB file to load the schema from.  [required]
      --program TEXT         Name of the program.  [required]
      --project TEXT         Name of the project.  [required]

    Example:
      gen3 pfb from -o data.avro tsv -s schema.avro --program DEV --project test /path/to/data/tsv/

### Make new blank record

    Usage: gen3 pfb make [OPTIONS] NAME

      Make a blank record according to given NODE schema in the PFB file.

    Options:
      -i, --input PFB  Read schema from this PFB file.  [default: <stdin>]

    Example:
      gen3 pfb make -i test.avro demographic > empty_demographic.json

### Add new record to PFB

    Usage: gen3 pfb add [OPTIONS] PFB

      Add records from a minified JSON file to the PFB file.

    Options:
      -i, --input JSON  The JSON file to add.  [default: <stdin>]

    Example:
      gen3 pfb add -i new_record.json pfb.avro

### Rename different parts of PFB (schema evolution)

    Usage: gen3 pfb rename [OPTIONS] COMMAND [ARGS]...

      Rename different parts of schema.

    Options:
      -i, --input FILENAME   Source PFB file.  [default: <stdin>]
      -o, --output FILENAME  Destination PFB file.  [default: <stdout>]

    Commands:
      enum  Rename enum.
      node  Rename node.
      type  Rename type (not implemented).

    Examples:
      enum:
        gen3 pfb rename -i data.avro -o data_enum.avro enum demographic_ethnicity old_enum new_enum
      node:
        gen3 pfb rename -i data.avro -o data_update.avro node demographic information

### Rename node

    Usage: gen3 pfb rename [PARENT OPTIONS] node [OPTIONS] OLD NEW

      Rename node from OLD to NEW.

### Rename enum

    Usage: gen3 pfb rename [PARENT OPTIONS] enum [OPTIONS] FIELD OLD NEW

      Rename enum of FIELD from OLD to NEW.

### Convert PFB into Neptune (bulk load format for Gremlin)

    Usage: gen3 pfb to [PARENT OPTIONS] gremlin [OPTIONS] [OUTPUT]

      Convert PFB into CSV files under OUTPUT for Neptune bulk load (Gremlin).

      The default OUTPUT is ./gremlin/.

    Options:
      --gzip / --no-gzip  Whether gzip the output.  [default: yes]

    Example:
      gen3 pfb to -i data.avro gremlin

### Convert PFB into TSV (1 TSV per node)

    Usage: gen3 pfb to [PARENT OPTIONS] tsv [OPTIONS] [OUTPUT]

      Convert PFB into TSV files under [OUTPUT] for modification of data in TSV format.

      The default [OUTPUT] is ./tsvs/.

    Options:
      None
    Example:
      gen3 pfb to -i data.avro tsv

### Example of minimal PFB
    In the examples/minimal-pfb directory we have an example of a minimal pfb that only contains submitted unaligned read data

    First create the PFB with schema from the json dictionary
    gen3 pfb from -o minimal_schema.avro dict minimal_file.json

    Then we put the data into the PFB
    gen3 pfb from -o minimal_data.avro json -s minimal_schema.avro --program DEV --project test sample_file_json/

    We can view the data of the PFB
    gen3 pfb show -i minimal_data.pfb

    We can also view the schema of the PFB
    gen3 pfb show -i minimal_data.pfb schema
