--Modify Deep Blue
function c511002769.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetLabel(0)
	e1:SetCost(c511002769.cost)
	e1:SetTarget(c511002769.target)
	e1:SetOperation(c511002769.activate)
	c:RegisterEffect(e1)
end
function c511002769.filter(c,rk)
	return c:GetLevel()==rk
end
function c511002769.xyzfilter(c,mg)
	return c:IsXyzSummonable(mg,1,mg:GetCount())
end
function c511002769.cfilter(c,e,tp)
	local rk=c:GetRank()
	local mg=Duel.GetMatchingGroup(c511002769.filter,tp,LOCATION_DECK,0,nil,rk)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsAbleToRemoveAsCost() 
		and mg:GetCount()>1 and Duel.IsExistingMatchingCard(c511002769.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
end
function c511002769.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c511002769.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 
			and Duel.IsExistingMatchingCard(c511002769.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,c511002769.cfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	Duel.SetTargetParam(rg:GetFirst():GetRank())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c511002769.activate(e,tp,eg,ep,ev,re,r,rp)
	local rk=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local mg=Duel.GetMatchingGroup(c511002769.filter,tp,LOCATION_DECK,0,nil,rk)
	local xyzg=Duel.GetMatchingGroup(c511002769.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,mg,1,mg:GetCount())
	end
end
