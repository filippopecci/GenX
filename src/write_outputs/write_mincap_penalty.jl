"""
GenX: An Configurable Capacity Expansion Model
Copyright (C) 2021,  Massachusetts Institute of Technology
This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
A complete copy of the GNU General Public License v2 (GPLv2) is available
in LICENSE.txt.  Users uncompressing this from an archive may not have
received this license file.  If not, see <http://www.gnu.org/licenses/>.
"""

function write_mincap_penalty(path::AbstractString, inputs::Dict, setup::Dict, EP::Model)
    NumberOfMinCapReqs = inputs["NumberOfMinCapReqs"]
    dfMinCapPenalty = DataFrame(Constraint = [Symbol("MinCap_$mincap") for mincap = 1:NumberOfMinCapReqs],
                                Price= dual.(EP[:cZoneMinCapReq]),
                                Slack = value.(EP[:vMinCap_slack]),
                                Penalty = value.(EP[:eCMinCap_slack]))
    if setup["ParameterScale"] == 1
        dfMinCapPenalty.Price *= ModelScalingFactor
        dfMinCapPenalty.Slack *= ModelScalingFactor
        dfMinCapPenalty.Penalty *= ModelScalingFactor^2
    end
    CSV.write(joinpath(path, "MinCap_Price_n_penalty.csv"), dfMinCapPenalty)
end