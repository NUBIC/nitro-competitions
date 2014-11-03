class ChangeProjectsColumnDefaults < ActiveRecord::Migration
  def up
    change_column_default :projects, :how_to_url_block, '<a href="/docs/NITRO-Competitions_Instructions.pdf" title="NITRO-Competitions Web Site Instructions/Help/HowTo">Site instructions</a>'
    change_column_default :projects, :rfp_url_block, '<a href="/docs/CTI_RFA.pdf" title="Pilot Proposal Request for Applications">CTI RFA</a>'
    change_column_default :projects, :help_document_url_block, '<a href="/docs/Pilot_Proposal_Form.doc" title="Pilot Proposal Form">Application template</a>
<a href="/docs/Application_Instructions.pdf" title="Pilot Proposal Application Instructions">Application instructions</a>
<a href="/docs/Pilot_Budget.doc" title="Pilot Proposal Budget Template">Budget Template</a>
<a href="/docs/Pilot_Budget_Instructions.pdf" title="Pilot Proposal Budget Instructions">Budget instructions</a>'
  end

  def down
    change_column_default :projects, :how_to_url_block, '<a href="/docs/NUCATS_Assist_Instructions.pdf" title="NUCATS Pilot Proposal Web Site Instructions/Help/HowTo">Site instructions</a>'
    change_column_default :projects, :rfp_url_block, '<a href="/docs/NUCATS_CTI_RFA.pdf" title="NUCATS Pilot Proposal Request for Applications">CTI RFA</a>'
    change_column_default :projects, :help_document_url_block, '<a href="/docs/NUCATS_Pilot_Proposal_Form.doc" title="NUCATS Pilot Proposal Form">Application template</a>
<a href="/docs/Application_Instructions.pdf" title="NUCATS Pilot Proposal Application Instructions">Application instructions</a>
<a href="/docs/NUCATS_Pilot_Budget.doc" title="NUCATS Pilot Proposal Budget Template">Budget Template</a>
<a href="/docs/Budget_Instructions.pdf" title="NUCATS Pilot Proposal Budget Instructions">Budget instructions</a>'
  end
end
