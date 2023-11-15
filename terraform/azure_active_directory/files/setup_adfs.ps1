
$region = "westus"
$rancherBase = "https://trusty-donkey-actually.ngrok-free.app"
$dnslabel = hostname
$metadataUrl = "$rancherBase/v1-saml/adfs/saml/metadata"
$serviceEndpoint = "$rancherBase/v1-saml/adfs/saml/acs"
$displayName = "TEST ADFS $dnslabel"
$issuer = "Active Directory"
$dnsEntries = @("$dnslabel.$region.cloudapp.azure.com", "$dnslabel")

$certThumbprint = (New-SelfSignedCertificate -DnsName $dnsEntries -CertStoreLocation Cert:\LocalMachine\My).Thumbprint
Install-AdfsFarm -CertificateThumbprint $certThumbprint -FederationServiceDisplayName "$dnslabel" -FederationServiceName "$dnslabel.$region.cloudapp.azure.com" -GroupServiceAccountIdentifier "ad\ADFSFarmService$"

$issuanceTransformRules = '@RuleName = "AllowAllUsers" => issue(Type = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier", Value = ".*");'
$identifierClaimRule = '@RuleName = "UPN", @RuleId = "userPrincipalName", @ClaimType = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/upn", @Value = ".*"'

Add-AdfsRelyingPartyTrust -Name $displayName -Metadataurl $metadataUrl
Set-AdfsRelyingPartyTrust -TargetName $displayName -AccessControlPolicyName "Permit everyone"

$issuanceTransformRules = '@RuleTemplate = "LdapClaims"
@RuleName = "ADMapping"
c:[Type == "http://schemas.microsoft.com/ws/2008/06/identity/claims/windowsaccountname", Issuer == "AD AUTHORITY"]
=> issue(store = "Active Directory", types = ("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname", "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/upn", "http://schemas.xmlsoap.org/claims/Group", "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"), query = ";givenName,userPrincipalName,tokenGroups(longDomainQualifiedName),sAMAccountName;{0}", param = c.Value);'
Set-AdfsRelyingPartyTrust -TargetName $displayName -IssuanceTransformRules $issuanceTransformRules
Restart-Service adfssrv
echo "Setup complete:  Your federation metadata should be accessible at https://$dnslabel.$region.cloudapp.azure.com/federationmetadata/2007-06/federationmetadata.xml"
