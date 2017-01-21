--Dimension Xyz
function c511000698.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c511000698.condition)
	e1:SetTarget(c511000698.target)
	e1:SetOperation(c511000698.operation)
	c:RegisterEffect(e1)
end
function c511000698.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=1000
end
function c511000698.filter(c,tp,xyz)
	local g=Duel.GetMatchingGroup(c511000698.filter2,tp,0x1e,0,nil,c:GetLevel(),c:GetCode(),xyz)
	return xyz:IsXyzSummonable(g,3,3) and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or c:IsLocation(LOCATION_MZONE))
end
function c511000698.filter2(c,lv,code,xyz)
	return c:IsXyzLevel(xyz,lv) and c:IsCode(code)
end
function c511000698.xyzfilter(c,tp)
	return Duel.IsExistingMatchingCard(c511000698.filter,tp,0x1e,0,1,nil,tp,c)
end
function c511000698.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c511000698.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c511000698.operation(e,tp,eg,ep,ev,re,r,rp)
	local xyzg=Duel.GetMatchingGroup(c511000698.xyzfilter,tp,LOCATION_EXTRA,0,nil,tp)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local mc=Duel.SelectMatchingCard(tp,c511000698.filter,tp,0x1e,0,1,1,nil,tp,xyz):GetFirst()
		local g=Duel.GetMatchingGroup(c511000698.filter2,tp,0x1e,0,nil,mc:GetLevel(),mc:GetCode(),xyz)
		Duel.XyzSummon(tp,xyz,g,3,3)
	end
end
