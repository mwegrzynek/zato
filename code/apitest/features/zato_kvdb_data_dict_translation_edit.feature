@kvdb.data-dict.translation
Feature: zato.kvdb.data-dict.translation.edit
  Edits a translation between two dictionary.

  @kvdb.data-dict.translation.edit
  Scenario: Set up

    Given I store "CRM" under "first_test_system"
    Given I store "CUSTOMER_TYPE" under "first_test_key"
    Given I store "QEQ" under "first_test_value"
    Given I store "PORTAL" under "second_test_system"
    Given I store "customerType" under "second_test_key"
    Given I store "292" under "second_test_value"
    Given I store "TEST" under "third_test_system"
    Given I store "test_key" under "third_test_key"
    Given I store "abcdefg12345" under "third_test_value"

  @kvdb.data-dict.translation.edit
  Scenario: Create first data dictionary entry in a cluster's KVDB

    Given address "$ZATO_API_TEST_SERVER"
    Given Basic Auth "$ZATO_API_TEST_PUBAPI_USER" "$ZATO_API_TEST_PUBAPI_PASSWORD"

    Given URL path "/zato/json/zato.kvdb.data-dict.dictionary.create"

    Given format "JSON"
    Given request is "{}"
    Given JSON Pointer "/system" in request is "#first_test_system"
    Given JSON Pointer "/key" in request is "#first_test_key"
    Given JSON Pointer "/value" in request is "#first_test_value"

    When the URL is invoked

    Then JSON Pointer "/zato_env/result" is "ZATO_OK"
    And I store "/zato_kvdb_data_dict_dictionary_create_response/id" from response under "first_dictionary_entry_id"

  @kvdb.data-dict.translation.edit
  Scenario: Create second data dictionary entry in a cluster's KVDB

    Given address "$ZATO_API_TEST_SERVER"
    Given Basic Auth "$ZATO_API_TEST_PUBAPI_USER" "$ZATO_API_TEST_PUBAPI_PASSWORD"

    Given URL path "/zato/json/zato.kvdb.data-dict.dictionary.create"

    Given format "JSON"
    Given request is "{}"
    Given JSON Pointer "/system" in request is "#second_test_system"
    Given JSON Pointer "/key" in request is "#second_test_key"
    Given JSON Pointer "/value" in request is "#second_test_value"

    When the URL is invoked

    Then JSON Pointer "/zato_env/result" is "ZATO_OK"
    And I store "/zato_kvdb_data_dict_dictionary_create_response/id" from response under "second_dictionary_entry_id"

  @kvdb.data-dict.translation.edit
  Scenario: Create third data dictionary entry in a cluster's KVDB

    Given address "$ZATO_API_TEST_SERVER"
    Given Basic Auth "$ZATO_API_TEST_PUBAPI_USER" "$ZATO_API_TEST_PUBAPI_PASSWORD"

    Given URL path "/zato/json/zato.kvdb.data-dict.dictionary.create"

    Given format "JSON"
    Given request is "{}"
    Given JSON Pointer "/system" in request is "#third_test_system"
    Given JSON Pointer "/key" in request is "#third_test_key"
    Given JSON Pointer "/value" in request is "#third_test_value"

    When the URL is invoked

    Then JSON Pointer "/zato_env/result" is "ZATO_OK"
    And I store "/zato_kvdb_data_dict_dictionary_create_response/id" from response under "third_dictionary_entry_id"

  @kvdb.data-dict.translation.edit
  Scenario: Invoke translation create

    Given address "$ZATO_API_TEST_SERVER"
    Given Basic Auth "$ZATO_API_TEST_PUBAPI_USER" "$ZATO_API_TEST_PUBAPI_PASSWORD"

    Given URL path "/zato/json/zato.kvdb.data-dict.translation.create"
    Given format "JSON"

    Given request is "{}"
    Given JSON Pointer "/system1" in request is "#first_test_system"
    Given JSON Pointer "/key1" in request is "#first_test_key"
    Given JSON Pointer "/value1" in request is "#first_test_value"
    Given JSON Pointer "/system2" in request is "#second_test_system"
    Given JSON Pointer "/key2" in request is "#second_test_key"
    Given JSON Pointer "/value2" in request is "#second_test_value"

    When the URL is invoked

    Then JSON Pointer "/zato_env/result" is "ZATO_OK"
    And JSON Pointer "/zato_kvdb_data_dict_translation_create_response/id" isn't empty
    And I store "/zato_kvdb_data_dict_translation_create_response/id" from response under "translation_id"

  @kvdb.data-dict.translation.edit
  Scenario: Edit the translation

    Given address "$ZATO_API_TEST_SERVER"
    Given Basic Auth "$ZATO_API_TEST_PUBAPI_USER" "$ZATO_API_TEST_PUBAPI_PASSWORD"

    Given URL path "/zato/json/zato.kvdb.data-dict.translation.edit"
    Given format "JSON"

    Given request is "{}"
    Given JSON Pointer "/id" in request is an integer "#translation_id"
    Given JSON Pointer "/system1" in request is "#second_test_system"
    Given JSON Pointer "/key1" in request is "#second_test_key"
    Given JSON Pointer "/value1" in request is "#second_test_value"
    Given JSON Pointer "/system2" in request is "#third_test_system"
    Given JSON Pointer "/key2" in request is "#third_test_key"
    Given JSON Pointer "/value2" in request is "#third_test_value"

    When the URL is invoked

    Then JSON Pointer "/zato_env/result" is "ZATO_OK"
    And JSON Pointer "/zato_kvdb_data_dict_translation_edit_response/id" is an integer "#translation_id"

  @kvdb.data-dict.translation.edit
  Scenario: Delete first test dictionary entry

    Given address "$ZATO_API_TEST_SERVER"
    Given Basic Auth "$ZATO_API_TEST_PUBAPI_USER" "$ZATO_API_TEST_PUBAPI_PASSWORD"

    Given URL path "/zato/json/zato.kvdb.data-dict.dictionary.delete"
    Given format "JSON"
    Given request is "{}"
    Given JSON Pointer "/id" in request is "#first_dictionary_entry_id"

    When the URL is invoked

    Then JSON Pointer "/zato_env/result" is "ZATO_OK"
    And JSON Pointer "/zato_kvdb_data_dict_dictionary_delete_response/id" is an integer "#first_dictionary_entry_id"

  @kvdb.data-dict.translation.edit
  Scenario: Delete second test dictionary entry

    Given address "$ZATO_API_TEST_SERVER"
    Given Basic Auth "$ZATO_API_TEST_PUBAPI_USER" "$ZATO_API_TEST_PUBAPI_PASSWORD"

    Given URL path "/zato/json/zato.kvdb.data-dict.dictionary.delete"
    Given format "JSON"
    Given request is "{}"
    Given JSON Pointer "/id" in request is "#second_dictionary_entry_id"

    When the URL is invoked

    Then JSON Pointer "/zato_env/result" is "ZATO_OK"
    And JSON Pointer "/zato_kvdb_data_dict_dictionary_delete_response/id" is an integer "#second_dictionary_entry_id"

