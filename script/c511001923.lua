--Trap Strap
function c511001923.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c511001923.condition)
	e1:SetTarget(c511001923.target)
	e1:SetOperation(c511001923.activate)
	c:RegisterEffect(e1)
end
function c511001923.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c511001923.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsCanTurnSet() end
end
function c511001923.spfilter(c,e,tp)
	return c:IsSetCard(0x1034) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511001923.activate(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	rc:CancelToGrave()
	Duel.ChangePosition(rc,POS_FACEDOWN)
	Duel.RaiseEvent(rc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	local spg=Duel.GetMatchingGroup(c511001923.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and spg:GetCount()>0 
		and Duel.SelectYesNo(tp,aux.Stringid(70245411,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sp=spg:Select(tp,1,1,nil)
		Duel.SpecialSummon(sp,0,tp,tp,false,false,POS_FACEUP)
	end
end
