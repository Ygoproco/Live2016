--Halfway to Forever
function c511001445.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511001445.target)
	e1:SetOperation(c511001445.activate)
	c:RegisterEffect(e1)
end
function c511001445.filter(c,tid)
	return c:GetTurnID()==tid and c:IsReason(REASON_BATTLE)
end
function c511001445.xyzfilter(c,mg)
	if c.xyz_count~=2 then return false end
	return c:IsXyzSummonable(mg)
end
function c511001445.mfilter1(c,exg)
	return exg:IsExists(c511001445.mfilter2,1,nil,c)
end
function c511001445.mfilter2(c,mc)
	return c.xyz_filter(mc)
end
function c511001445.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tid=Duel.GetTurnCount()
	local mg=Duel.GetMatchingGroup(c511001445.filter,tp,LOCATION_GRAVE,0,nil,tid)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and mg:GetCount()>1
		and Duel.IsExistingMatchingCard(c511001445.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,mg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c511001445.activate(e,tp,eg,ep,ev,re,r,rp)
	local tid=Duel.GetTurnCount()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local mg=Duel.GetMatchingGroup(c511001445.filter,tp,LOCATION_GRAVE,0,nil,tid)
	local exg=Duel.GetMatchingGroup(c511001445.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg1=mg:FilterSelect(tp,c511001445.mfilter1,1,1,nil,exg)
	local tc1=sg1:GetFirst()
	local exg2=exg:Filter(c511001445.mfilter2,nil,tc1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg2=mg:FilterSelect(tp,c511001445.mfilter1,1,1,tc1,exg2)
	sg1:Merge(sg2)
	local xyzg=Duel.GetMatchingGroup(c511001445.xyzfilter,tp,LOCATION_EXTRA,0,nil,sg1)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		xyz:SetMaterial(sg1)
		Duel.Overlay(xyz,sg1)
		Duel.SpecialSummon(xyz,SUMMON_TYPE_XYZ,tp,tp,true,false,POS_FACEUP)
		xyz:CompleteProcedure()
	end
end
