--スパイダー・ウェブ
function c511002589.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--to defense
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DAMAGE_STEP_END)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c511002589.poscon)
	e2:SetOperation(c511002589.posop)
	c:RegisterEffect(e2)
end
function c511002589.poscon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	return a:IsPosition(POS_FACEUP_ATTACK) and a:IsRelateToBattle() and a:IsControler(1-tp) 
		and not a:IsRace(RACE_INSECT)
end
function c511002589.posop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	if Duel.ChangePosition(a,POS_FACEUP_DEFENSE)~=0 then
		e:GetHandler():CreateRelation(a,RESET_EVENT+0x1fe0000)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,3)
		e1:SetCondition(c511002589.poscon2)
		a:RegisterEffect(e1)
	end
end
function c511002589.poscon2(e)
	return e:GetOwner():IsRelateToCard(e:GetHandler())
end
