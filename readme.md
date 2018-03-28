# PowerTDE

This module helps configuring SQL Server Transparent Database Encryption. I created it to help me enable TDE on lots of SQL databases, a company policy to cover a part of the GDPR requirements we're facing. Currently, only the functions to manage the database encryption key and to enable/disable encryption are finished.  The configuration of the server level (certificate etc.) will follow.  The server-level config will cover both SQL Server-generated keys and using an EKM module.

Bert Van Landeghem - 2018/02/07


