# Local database

- The development database is MySQL 5.5.62 at `localhost`, database `emmebi`.
- The local account verified on this workstation is `root`, without a password. This applies only to the local development instance; do not assume the same access on other hosts.
- The client is available as `mysql` in PowerShell. Its installed path is `C:\Program Files\MySQL\MySQL Server 5.5\bin\mysql.exe`.
- Verify the connection with:

```powershell
mysql --host=localhost --user=root --database=emmebi --connect-timeout=5 --batch --execute="SELECT DATABASE(), VERSION(), CURRENT_USER();"
```

- Save SQL containing accented identifiers such as `quantità` as UTF-8 and run it through a file:

```powershell
mysql --host=localhost --user=root --database=emmebi --default-character-set=utf8 --batch --execute="source C:/absolute/path/script.sql"
```

- Passing non-ASCII SQL directly through `--execute` can be corrupted by the Windows command-line encoding. Inspect both the exit code and output for `ERROR`: this legacy client can report errors from a sourced file without returning a nonzero exit code.
- Diagnose with ordinary `EXPLAIN`, `SHOW INDEX` and `information_schema`. This server does not support `EXPLAIN ANALYZE`, CTEs or window functions. Diagnostic scripts for the report export are in `aries/MyTool/report_export_diagnostics`.
- Default to read-only inspection. Apply database changes when authorized by the task; before replacing a procedure, save its `SHOW CREATE PROCEDURE` definition outside the repository with working `DELIMITER` statements. In PowerShell, use single-quoted strings for the literal `$$` delimiter.
- Stop only queries started by the agent. Leave pre-existing sessions running unless the user explicitly authorizes stopping them.
- Keep changes in `aries/StoredProcedure` aligned with the corresponding dated `aries/YYYY-MM-DD/script.sql` migration. Preserve existing export column names and order unless the task asks to change them.
- MySQL 5.5 cannot reopen the same temporary table multiple times in one query. Aggregate independent detail families in separate statements and index temporary tables by their join keys.
- Do not commit database dumps containing customer data, query-result exports or credentials. Local backups and diagnostic outputs belong outside the repository.
