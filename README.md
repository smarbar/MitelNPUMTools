# MitelNPUMTools
Mitel NPUM Voicemail Tools

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/smarbar/MitelNPUMTools/blob/main/LICENSE)
[![Documentation - GitHub](https://img.shields.io/badge/Documentation-MitelNPUMTools-blue.svg)](https://github.com/smarbar/MitelNPUMTools/tree/master/docs)
[![PowerShell Gallery - MitelNPUMTools](https://img.shields.io/badge/PowerShell%20Gallery-MitelNPUMTools-blue.svg)](https://www.powershellgallery.com/packages/MitelNPUMTools)
[![Minimum Supported PowerShell Version](https://img.shields.io/badge/PowerShell-5.1-blue.svg)](https://github.com/smarbar/MitelNPUMTools)
[![deploy-mitelnpumtools](https://github.com/smarbar/MitelNPUMTools/actions/workflows/deploy-module.yaml/badge.svg)](https://github.com/smarbar/MitelNPUMTools/actions/workflows/deploy-module.yaml)
<a href="https://www.repostatus.org/#active"><img src="https://www.repostatus.org/badges/latest/active.svg" alt="Project Status: Active – The project has reached a stable, usable state and is being actively developed." /></a>

## Overview

MitelNPUMTools provides an easy way to upload and apply greetings to a Mitel NuPoint voicemail box either individually or in bulk.

Greetings must be in the following format. 
CCITT u-law, 8KHz, 8 bit, mono.

### Installation

```powershell
# Release
Install-Module -Name MitelNPUMTools
```

### Documentation

- All help is available in [/docs](/docs)
- External Help is available as XML
- Markdown files for all CmdLets created automatically with PlatyPS and updated with each Version