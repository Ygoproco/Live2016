--Soldier Revolt
function c511001897.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c511001897.condition)
	e1:SetTarget(c511001897.target)
	e1:SetOperation(c511001897.activate)
	c:RegisterEffect(e1)
end
function c511001897.cfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c511001897.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetActivityCount(tp,ACTIVITY_BATTLE_PHASE)==0 
		and Duel.IsExistingMatchingCard(c511001897.cfilter,tp,LOCATION_ONFIELD,0,1,nil,79853073)
		and Duel.IsExistingMatchingCard(c511001897.cfilter,tp,LOCATION_ONFIELD,0,1,nil,67532912)
		and Duel.IsExistingMatchingCard(c511001897.cfilter,tp,LOCATION_ONFIELD,0,1,nil,75559356)
end
function c511001897.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND+LOCATION_ONFIELD)~=0 end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c511001897.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND+LOCATION_ONFIELD)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BP)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
