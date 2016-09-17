--高等紋章術
function c511002746.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511002746.target)
	e1:SetOperation(c511002746.activate)
	c:RegisterEffect(e1)
end
function c511002746.xyzfilter(c,mg)
	local ct=c.xyz_count
	return c:IsXyzSummonable(mg) and ct<=mg:GetCount() and mg:IsExists(c511002746.mfilter,ct,nil,c)
end
function c511002746.mfilter(c,xyz)
	return xyz.xyz_filter(c) and c:IsCanBeXyzMaterial(xyz)
end
function c511002746.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0x76)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and mg:GetCount()>1
		and Duel.IsExistingMatchingCard(c511002746.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,mg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c511002746.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0x76)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local xyzg=Duel.GetMatchingGroup(c511002746.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		local ct=xyz.xyz_count
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=mg:FilterSelect(tp,c511002746.mfilter,ct,ct,nil,xyz)
		Duel.XyzSummon(tp,xyz,g)
	end
end
