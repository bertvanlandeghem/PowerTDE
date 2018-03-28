#Requires -Modules Pester
<#
.SYNOPSIS
    Tests a module for all needed components
.EXAMPLE
    Invoke-Pester 
.NOTES
    This is a very generic set of tests that should apply to all modules that use a functions sub folder
#>


$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$module = Split-Path -Leaf $here

Describe "Module: $module" -Tags Unit {
    
    Context "Module Configuration" {
        
        It "Has a root module file ($module.psm1)" {        
            
            "$here\$module.psm1" | Should Exist
        }

        It "Is valid Powershell (Has no script errors)" {

            $contents = Get-Content -Path "$here\$module.psm1" -ErrorAction SilentlyContinue
            $errors = $null
            $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
            $errors.Count | Should Be 0
        }

        It "Has a manifest file ($module.psd1)" {
            
            "$here\$module.psd1" | Should Exist
        }

        It "Contains a root module path in the manifest (RootModule = '.\$module.psm1')" {
            
            "$here\$module.psd1" | Should Exist
            "$here\$module.psd1" | Should FileContentMatch "\.\\$module.psm1"
        }

        It "Has a functions folder" {        
            
            "$here\functions" | Should Exist
        }

        It "Has functions in the functions folder" {        
            
            "$here\functions\*.ps1" | Should Exist
        }
    }

    #Demo Note: Reminder that Pester commands are just Powershell commands

    $Functions = Get-ChildItem "$here\functions\*.ps1" -ErrorAction SilentlyContinue | 
        Where-Object {$_.name -NotMatch "Tests.ps1"}

    foreach($CurrentFunction in $Functions)
    {
        Context "Function $module::$($CurrentFunction.BaseName)" {
        
            It "Has a Pester test" {

                $CurrentFunction.FullName.Replace(".ps1",".Tests.ps1") | should exist
            }

            It "Has show-help comment block" {

                $CurrentFunction.FullName | Should FileContentMatch '<#'
                $CurrentFunction.FullName | Should FileContentMatch '#>'
            }

            It "Has show-help comment block has a synopsis" {

                $CurrentFunction.FullName | Should FileContentMatch '\.SYNOPSIS'
            }

            It "Has show-help comment block has an example" {

                $CurrentFunction.FullName | Should FileContentMatch '\.EXAMPLE'
            }

            It "Is an advanced function" {

                $CurrentFunction.FullName | Should FileContentMatch 'function'
                $CurrentFunction.FullName | Should FileContentMatch 'cmdletbinding'
                $CurrentFunction.FullName | Should FileContentMatch 'param'
            }

            It "Is valid Powershell (Has no script errors)" {

                $contents = Get-Content -Path $CurrentFunction.FullName -ErrorAction Stop
                $errors = $null
                $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
                $errors.Count | Should Be 0
            }

            Context "Function $module::$($CurrentFunction.BaseName) Conforms PSScriptAnalyzer Standard Rules" {
                # https://workingsysadmin.com/invoking-pester-and-psscriptanalyzer-tests-in-hosted-vsts/
                $analysis = Invoke-ScriptAnalyzer -Path $CurrentFunction.FullName
                $scriptAnalyzerRules = Get-ScriptAnalyzerRule
         
                forEach ($rule in $scriptAnalyzerRules) {
                    It "Should pass $rule" {
                        If ($analysis.RuleName -contains $rule) {
                            $analysis | Where-Object RuleName -eq $rule -outvariable failures | Out-Null
                            $failures.Count | Should Be 0
                        }
                    }
                }
            }
        }
    }
}