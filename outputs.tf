output "sp_app_id"{
    value = azuread_service_principal.sp.application_id
}

output "sp_secret"{
    value = azuread_service_principal_password.createsppwd.id
    description = "sp secret ID"
}