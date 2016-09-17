--coded by Lyris
--Damage Boost
function c511007024.initial_effect(c)
	--Activate only when your opponent activates a card effect that would negate the effect of a card you control that inflicts damage to your opponent. Negate the effect, and destroy that card. Then, double the damage inflicted to your opponent. [The Legendary Fisherman III]
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCondition(c511007024.condition)
	e1:SetTarget(c511007024.target)
	e1:SetOperation(c511007024.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCondition(c511007024.condition2)
	c:RegisterEffect(e2)
end
function c511007024.condition(e,tp,eg,ep,ev,re,r,rp)
	if tp==ep or not Duel.IsChainNegatable(ev) then return false end
	if not re:IsActiveType(TYPE_MONSTER) and not re:IsActiveType(TYPE_TRAP) and not re:IsHasType(EFFECT_TYPE_ACTIVATE)  then return false end
	local tex,ttg,ttc=Duel.GetOperationInfo(ev,CATEGORY_NEGATE)
	if not tex or ttg==nil or ttc+ttg:FilterCount(Card.IsControler,nil,tp)-ttg:GetCount()<=0 then return false end
	local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev-1,CATEGORY_DAMAGE)
	if ex and (cp~=tp or cp==PLAYER_ALL) then return true end
	ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev-1,CATEGORY_RECOVER)
	return ex and (cp~=tp or cp==PLAYER_ALL) and Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_REVERSE_RECOVER)
end
function c511007024.condition2(e,tp,eg,ep,ev,re,r,rp)
	if tp==ep or not Duel.IsChainNegatable(ev) then return false end
	if not re:IsActiveType(TYPE_MONSTER) and not re:IsActiveType(TYPE_TRAP) and not re:IsHasType(EFFECT_TYPE_ACTIVATE)  then return false end
	local tex,ttg,ttc=Duel.GetOperationInfo(ev,CATEGORY_DISABLE)
	if not tex or ttg==nil or ttc+ttg:FilterCount(Card.IsControler,nil,tp)-ttg:GetCount()<=0 then return false end
	local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev-1,CATEGORY_DAMAGE)
	if ex and (cp~=tp or cp==PLAYER_ALL) then return true end
	ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev-1,CATEGORY_RECOVER)
	return ex and (cp~=tp or cp==PLAYER_ALL) and Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_REVERSE_RECOVER)
end
function c511007024.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsDestructable() then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,re:GetHandler(),1,0,0)
	end
end
function c511007024.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(re:GetHandler(),REASON_EFFECT)~=0 then
		--Duel.BreakEffect()
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CHANGE_DAMAGE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(0,1)
		e2:SetValue(c511007024.damop)
		e2:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e2,tp)
		Duel.RegisterFlagEffect(tp,511007024,RESET_PHASE+PHASE_END,0,1)
	end
end
function c511007024.damop(e,re,val,r,rp,rc)
	local tp=e:GetHandlerPlayer()
	local cc=Duel.GetCurrentChain()
	if cc==0 or rp~=tp or bit.band(r,REASON_EFFECT)==0 or Duel.GetFlagEffect(tp,511007024)==0 then return val end
	Duel.ResetFlagEffect(tp,511007024)
	return val*2
end
