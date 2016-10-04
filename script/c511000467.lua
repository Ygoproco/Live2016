--Sand Fortress
function c511000467.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c511000467.atkcon)
	e2:SetOperation(c511000467.atkop)
	c:RegisterEffect(e2)
	if not c511000467.global_check then
		c511000467.global_check=true
		--move
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_SSET)
		ge1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_IMMEDIATELY_APPLY)
		ge1:SetOperation(c511000467.setop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c511000467.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsCode,nil,511000467)
	local tc=g:GetFirst()
	while tc do
		local fc=Duel.GetFieldCard(tc:GetControler(),LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveSequence(tc,5)
		tc=g:GetNext()
	end
end
function c511000467.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttackTarget()==nil and ep==tp
end
function c511000467.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(51100467)==0 then
		c:RegisterFlagEffect(51100467,RESET_EVENT+0x1fe0000,0,0)
		e:SetLabel(0)
	end
	local dam=e:GetLabel()
	Duel.ChangeBattleDamage(tp,0)
	e:SetLabel(dam+ev)
	if e:GetLabel()>=3000 then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
