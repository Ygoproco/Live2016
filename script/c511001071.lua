--Hero's Guard
function c511001071.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c511001071.condition)
	e1:SetOperation(c511001071.activate)
	c:RegisterEffect(e1)
end
function c511001071.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():IsControler(1-tp)
end
function c511001071.activate(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	if d and d:IsSetCard(0x8) then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetValue(1)
		e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
		d:RegisterEffect(e2)
		if Duel.IsExistingMatchingCard(c511001071.cfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) 
			and Duel.SelectYesNo(tp,aux.Stringid(52687916,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g=Duel.SelectMatchingCard(tp,c511001071.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
			Duel.Remove(g,POS_FACEUP,REASON_COST)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CHANGE_DAMAGE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
			e1:SetTargetRange(1,0)
			e1:SetValue(c511001071.damval)
			Duel.RegisterEffect(e1,tp)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function c511001071.cfilter(c)
	return c:IsSetCard(0x8) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c511001071.damval(e,re,val,r,rp,rc)
	if r==REASON_BATTLE then
		return val/2
	else return val end
end
