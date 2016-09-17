--Rescue Xyz
function c511001874.initial_effect(c)
	--synchro effect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511001874.target)
	e1:SetOperation(c511001874.activate)
	c:RegisterEffect(e1)
end
function c511001874.filter(c)
	return c:IsFaceup() and c:GetOwner()~=c:GetControler()
end
function c511001874.xyzfilter(c,mg)
	return c:IsXyzSummonable(mg) and c.xyz_count<=mg:GetCount()
end
function c511001874.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(c511001874.filter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(c511001874.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,mg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c511001874.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(c511001874.filter,tp,0,LOCATION_MZONE,nil)
	local g=Duel.GetMatchingGroup(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,nil,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=g:Select(tp,1,1,nil):GetFirst()
		if mg:GetCount()>xyz.xyz_count then
			mg=mg:Select(tp,xyz.xyz_count,xyz.xyz_count,nil)
		end
		Duel.XyzSummon(tp,xyz,mg)
	end
end
