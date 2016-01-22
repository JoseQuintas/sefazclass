1) Copiar as DLLs

Se Windows 32 bits: copiar para c:\windows\system32
Se Windows 64 bits: copiar para c:\windows\syswow64

2) Registrar

Tem que ser na pasta conforme acima, porque tem mais de um regsvr32.exe no Windows
E como administrador. Pelo menos uma delas não aceita registrar como usuário comum.

regsvr32.exe capicom.dll
regsvr32.exe msxml5.dll

3) Somente certificados válidos, remova certificados vencidos
