
#define CAPICOM_AUTHENTICATED_ATTRIBUTE_SIGNING_TIME             0
#define CAPICOM_AUTHENTICATED_ATTRIBUTE_DOCUMENT_NAME            1
#define CAPICOM_AUTHENTICATED_ATTRIBUTE_DOCUMENT_DESCRIPTION     2

#define CAPICOM_CERTIFICATE_FIND_SHA1_HASH                       0
#define CAPICOM_CERTIFICATE_FIND_SUBJECT_NAME                    1
#define CAPICOM_CERTIFICATE_FIND_ISSUER_NAME                     2
#define CAPICOM_CERTIFICATE_FIND_ROOT_NAME                       3
#define CAPICOM_CERTIFICATE_FIND_TEMPLATE_NAME                   4
#define CAPICOM_CERTIFICATE_FIND_EXTENSION                       5
#define CAPICOM_CERTIFICATE_FIND_EXTENDED_PROPERTY               6
#define CAPICOM_CERTIFICATE_FIND_APPLICATION_POLICY              7
#define CAPICOM_CERTIFICATE_FIND_CERTIFICATE_POLICY              8
#define CAPICOM_CERTIFICATE_FIND_TIME_VALID                      9
#define CAPICOM_CERTIFICATE_FIND_TIME_NOT_YET_VALID              10
#define CAPICOM_CERTIFICATE_FIND_TIME_EXPIRED                    11
#define CAPICOM_CERTIFICATE_FIND_KEY_USAGE                       12

#define CAPICOM_CERTIFICATE_INCLUDE_CHAIN_EXCEPT_ROOT            0
#define CAPICOM_CERTIFICATE_INCLUDE_WHOLE_CHAIN                  1
#define CAPICOM_CERTIFICATE_INCLUDE_END_ENTITY_ONLY              2

// CAPICOM Chain check flag
#define CAPICOM_CHECK_NONE                                       &H00000000
#define CAPICOM_CHECK_TRUSTED_ROOT                               &H00000001
#define CAPICOM_CHECK_TIME_VALIDITY                              &H00000002
#define CAPICOM_CHECK_SIGNATURE_VALIDITY                         &H00000004
#define CAPICOM_CHECK_ONLINE_REVOCATION_STATUS                   &H00000008
#define CAPICOM_CHECK_OFFLINE_REVOCATION_STATUS                  &H00000010
#define CAPICOM_CHECK_COMPLETE_CHAIN                             &H00000020
#define CAPICOM_CHECK_NAME_CONSTRAINTS                           &H00000040
#define CAPICOM_CHECK_BASIC_CONSTRAINTS                          &H00000080
#define CAPICOM_CHECK_NESTED_VALIDITY_PERIOD                     &H00000100
#define CAPICOM_CHECK_ONLINE_ALL                                 &H000001EF
#define CAPICOM_CHECK_OFFLINE_ALL                                &H000001F7

#define CAPICOM_ENCRYPTION_ALGORITHM_RC2                         0
#define CAPICOM_ENCRYPTION_ALGORITHM_RC4                         1
#define CAPICOM_ENCRYPTION_ALGORITHM_DES                         2
#define CAPICOM_ENCRYPTION_ALGORITHM_3DES                        3
#define CAPICOM_ENCRYPTION_ALGORITHM_AES                         4 // v2.0

#define CAPICOM_ENCRYPTION_KEY_LENGTH_MAXIMUM                    0
#define CAPICOM_ENCRYPTION_KEY_LENGTH_40_BITS                    1
#define CAPICOM_ENCRYPTION_KEY_LENGTH_56_BITS                    2
#define CAPICOM_ENCRYPTION_KEY_LENGTH_128_BITS                   3
#define CAPICOM_ENCRYPTION_KEY_LENGTH_192_BITS                   4 // AES v2.0
#define CAPICOM_ENCRYPTION_KEY_LENGTH_256_BITS                   5 // AES v2.0

#define CAPICOM_ENCODE_ANY                                       0xffffffff
#define CAPICOM_ENCODE_BASE64                                    0
#define CAPICOM_ENCODE_BINARY                                    1

#define CAPICOM_EXPORT_DEFAULT                                   0
#define CAPICOM_EXPORT_IGNORE_PRIVATE_KEY_NOT_EXPORTABLE_ERROR   1

#define CAPICOM_HASH_ALGORITHM_SHA1                              0
#define CAPICOM_HASH_ALGORITHM_MD2                               1
#define CAPICOM_HASH_ALGORITHM_MD4                               2
#define CAPICOM_HASH_ALGORITHM_MD5                               3
#define CAPICOM_HASH_ALGORITHM_SHA_256                           4
#define CAPICOM_HASH_ALGORITHM_SHA_384                           5
#define CAPICOM_HASH_ALGORITHM_SHA_512                           6

#define CAPICOM_KEY_STORAGE_DEFAULT                              0
#define CAPICOM_KEY_STORAGE_EXPORTABLE                           1
#define CAPICOM_KEY_STORAGE_USER_PROTECTED                       2

#define CAPICOM_MY_STORE                                         "My"

#define CAPICOM_PROPID_KEY_PROV_INFO                             2

#define CAPICOM_STORE_OPEN_READ_ONLY                             0
#define CAPICOM_STORE_OPEN_READ_WRITE                            1
#define CAPICOM_STORE_OPEN_MAXIMUM_ALLOWED                       2
#define CAPICOM_STORE_OPEN_EXISTING_ONLY                         128
#define CAPICOM_STORE_OPEN_INCLUDE_ARCHIVED                      256

#define CAPICOM_STORE_SAVE_AS_SERIALIZED                         0
#define CAPICOM_STORE_SAVE_AS_PKCS7                              1
#define CAPICOM_STORE_SAVE_AS_PFX                                2

#define CAPICOM_MEMORY_STORE                                     0
#define CAPICOM_LOCAL_MACHINE_STORE                              1
#define CAPICOM_CURRENT_USER_STORE                               2
#define CAPICOM_ACTIVE_DIRECTORY_USER_STORE                      3
#define CAPICOM_SMART_CARD_USER_STORE                            4

// CAPICOM Chain check flag
#define CAPICOM_TRUST_IS_NOT_TIME_VALID                          &H00000001
#define CAPICOM_TRUST_IS_NOT_TIME_NESTED                         &H00000002
#define CAPICOM_TRUST_IS_REVOKED                                 &H00000004
#define CAPICOM_TRUST_IS_NOT_SIGNATURE_VALID                     &H00000008
#define CAPICOM_TRUST_IS_NOT_VALID_FOR_USAGE                     &H00000010
#define CAPICOM_TRUST_IS_UNTRUSTED_ROOT                          &H00000020
#define CAPICOM_TRUST_REVOCATION_STATUS_UNKNOWN                  &H00000040
#define CAPICOM_TRUST_IS_CYCLIC                                  &H00000080
#define CAPICOM_TRUST_INVALID_EXTENSION                          &H00000100
#define CAPICOM_TRUST_INVALID_POLICY_CONSTRAINTS                 &H00000200
#define CAPICOM_TRUST_INVALID_BASIC_CONSTRAINTS                  &H00000400
#define CAPICOM_TRUST_INVALID_NAME_CONSTRAINTS                   &H00000800
#define CAPICOM_TRUST_HAS_NOT_SUPPORTED_NAME_CONSTRAINT          &H00001000
#define CAPICOM_TRUST_HAS_NOT_DEFINED_NAME_CONSTRAINT            &H00002000
#define CAPICOM_TRUST_HAS_NOT_PERMITTED_NAME_CONSTRAINT          &H00004000
#define CAPICOM_TRUST_HAS_EXCLUDED_NAME_CONSTRAINT               &H00008000
#define CAPICOM_TRUST_IS_OFFLINE_REVOCATION                      &H01000000
#define CAPICOM_TRUST_NO_ISSUANCE_CHAIN_POLICY                   &H02000000
#define CAPICOM_TRUST_IS_PARTIAL_CHAIN                           &H00010000
#define CAPICOM_TRUST_CTL_IS_NOT_TIME_VALID                      &H00020000
#define CAPICOM_TRUST_CTL_IS_NOT_SIGNATURE_VALID                 &H00040000
#define CAPICOM_TRUST_CTL_IS_NOT_VALID_FOR_USAGE                 &H00080000
#define KNOWN_TRUST_STATUS_MASK                                  &H030FFFFF

#define CAPICOM_VERIFY_SIGNATURE_ONLY                            0
#define CAPICOM_VERIFY_SIGNATURE_AND_CERTIFICATE                 1
