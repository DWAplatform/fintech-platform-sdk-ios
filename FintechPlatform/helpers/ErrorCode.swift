//
//  ErrorCode.swift
//  FintechPlatform
//
//  Created by ingrid on 14/05/18.
//  Copyright © 2018 Fintech Platform. All rights reserved.
//

import Foundation

public enum ErrorCode: String {
    case unknown_error
    case invalid_parameter
    case asp_generic_error
    case asp_specific_error
    case asp_not_implemented
    case asp_secure_mode_3dsecure_authentication_has_failed
    case asp_insufficient_wallet_balance
    case asp_author_is_not_wallet_owner
    case asp_transaction_amount_is_higher_than_maximum_permitted_amount
    case asp_transaction_amount_is_lower_than_lower_permitted_amount
    case asp_invalid_transaction_amount
    case asp_creditedfunds_must_be_more_than_0
    case asp_user_has_not_been_redirected
    case asp_user_canceled_the_payment
    case asp_user_is_filling_in_the_payment_card_details
    case asp_user_has_not_been_redirected_then_the_payment_session_has_expired
    case asp_user_has_let_the_payment_session_expire_without_paying
    case asp_transaction_has_been_cancelled_by_the_user
    case asp_transaction_has_already_been_successfully_refunded
    case asp_refund_cannot_exceed_initial_transaction_amount
    case asp_generic_operation_error
    case asp_refunded_fees_cannot_exceed_initial_fee_amount
    case asp_balance_of_client_fee_wallet_insufficient
    case asp_duplicated_operation
    case asp_transaction_cannot_be_refunded
    case asp_invalid_card_number
    case asp_invalid_cardholder_name
    case asp_invalid_pin_code
    case asp_invalid_pin_format
    case asp_invalid_card_date
    case asp_invalid_cvv_number
    case asp_transaction_refused_by_the_bank
    case asp_transaction_refused_by_the_bank_amount_limit
    case asp_transaction_refused_by_the_terminal
    case asp_transaction_refused_by_the_bank_card_limit_reached
    case asp_the_card_has_expired
    case asp_the_card_is_inactive
    case asp_debited_wallet_credited_wallet_must_be_different
    case asp_payment_period_expired
    case asp_payment_refused
    case asp_card_not_active
    case asp_maximum_number_of_attempts_reached
    case asp_maximum_amount_exceeded
    case asp_maximum_uses_exceeded
    case asp_debit_limit_exceeded
    case asp_amount_limit
    case asp_initial_transaction_whit_same_card_pending
    case asp_transaction_refused
    case asp_secure_mode_3dsecure_authentication_is_not_available
    case asp_secure_mode_the_card_is_not_enrolled_with_3dsecure
    case asp_secure_mode_the_card_is_not_compatible_with_3dsecure
    case asp_secure_mode_the_3dsecure_authentication_session_has_expired
    case asp_token_processing_error
    case asp_token_input_error
    case asp_card_number_invalid_format
    case asp_expiry_date_missing_or_invalid_format
    case asp_CVV_missing_or_invalid_format
    case asp_callback_URL_invalid_format
    case asp_registration_data_invalid_format
    case asp_card_registration_should_return_valid_JSON_response
    case asp_internal_error
    case asp_method_GET_not_allowed
    case asp_user_or_password_incorrect
    case asp_account_is_locked_or_inactive
    case asp_card_is_not_active
    case asp_client_certificate_is_disabled
    case asp_permission_denied
    case asp_delay_exceeded
    case asp_http_request_blocked_by_antivirus
    case asp_browser_doesnt_support_cross_origin_ajax_calls
    case asp_http_request_failed
    case asp_cross_origin_http_request_failed
    case asp_max_accounts_exceeded
    case asp_blocked_due_to_a_debited_user_kyc_limitations
    case asp_blocked_due_to_the_bank_account_owner_kyc_limitations
    case asp_fraud_policy_error
    case asp_counterfeit_card
    case asp_lost_card
    case asp_stolen_card
    case asp_card_bin_not_authorized
    case asp_security_violation
    case asp_fraud_suspected_by_the_bank
    case asp_temporary_opposition_by_bank
    case asp_transaction_refused_by_fraud_policy
    case asp_wallet_blocked_by_fraud_policy
    case asp_user_blocked_by_fraud_policy
    case asp_number_transaction_exceeded_velocity_limit_set
    case asp_unauthorized_ip_address_country
    case asp_value_transactions_exceeded
    case asp_unauthorized_card_issuer_country
    case asp_number_cards_allowed_exceeded
    case asp_number_clients_card_exceeded
    case asp_S3D_auth_failed_due_supplementary_security_checks
    case asp_IP_location_different_from_country_issuer
    case asp_device_fingerprints_allowed_exceeded
    case asp_psp_configuration_error
    case asp_psp_technical_error
    case asp_bank_technical_error
    case asp_psp_timeout
    case asp_generic_withdrawal_error
    case asp_bank_wire_refused
    case asp_bank_account_inactive
    case asp_generic_exception
    case kyc_document_unreadable
    case kyc_document_not_accepted
    case kyc_document_has_expired
    case kyc_document_incomplete
    case kyc_document_missing
    case kyc_document_do_not_match_user_data
    case kyc_document_do_not_match_account_data
    case kyc_document_falsified
    case kyc_underage_person
    case kyc_specific_case
    case kyc_uncodified_error
    case firebase_exception
    case resource_not_found
    case generic_exception
    case authentication_error
    case invalid_request
    case invalid_client
    case invalid_scope
    case user_already_exists
}
