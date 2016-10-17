--Tri-Slice
function c511001359.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c511001359.cost)
	e1:SetTarget(c511001359.target)
	e1:SetOperation(c511001359.operation)
	c:RegisterEffect(e1)
end
function c511001359.cfilter(c,e,tp)
	local clv=c:GetLevel()
	return clv>0 and c:IsRace(RACE_FISH) and (clv==6 or clv==9 or clv==12)
		and Duel.IsExistingMatchingCard(c511001359.spfilter,tp,LOCATION_DECK,0,3,nil,clv/3,e,tp)
end
function c511001359.spfilter(c,slv,e,tp)
	return c:GetLevel()==slv and c:IsAttribute(ATTRIBUTE_WATER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511001359.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c511001359.cfilter,1,nil,e,tp) end
	local g=Duel.SelectReleaseGroup(tp,c511001359.cfilter,1,1,nil,e,tp)
	e:SetLabel(g:GetFirst():GetLevel()/3)
	Duel.Release(g,REASON_COST)
end
function c511001359.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,0,0)
end
function c511001359.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=2 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c511001359.spfilter,tp,LOCATION_DECK,0,3,3,nil,e:GetLabel(),e,tp)
	if g:GetCount()>2 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
