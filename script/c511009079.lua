--Raptor's Intercept Form
function c511009079.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1)
	e2:SetCondition(c511009079.atkcon)
	-- e2:SetTarget(c511009079.atktg)
	e2:SetOperation(c511009079.atkop)
	c:RegisterEffect(e2)
	
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(95100820,0))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c511009079.negcon)
	e3:SetOperation(c511009079.negop)
	c:RegisterEffect(e3)
end
function c511009079.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if Duel.IsDamageCalculated() then return false end
	local tc=Duel.GetAttackTarget()
	local d=Duel.GetAttacker()
	if not tc or tc:IsControler(1-tp) then return false end
	e:SetLabelObject(tc)
	return d and tc and tc:IsFaceup() and tc:IsSetCard(0xba) and tc:IsRelateToBattle()  and d:IsRelateToBattle() 
		and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function c511009079.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=e:GetLabelObject()
	if chkc then return chkc==tc end
	if chk==0 then return tc and tc:IsOnField() and tc:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tc)
end
function c511009079.atkop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if not c:IsRelateToEffect(e) or not tc or not tc:IsRelateToBattle() or tc:IsFacedown() then return end
	local atk=tc:GetAttack()
	local def=tc:GetDefence()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(def)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(atk)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
		tc:RegisterEffect(e2)	
		
end

--------------------------------------------
function c511009079.tfilter(c,tp)
	return c:IsFaceup() and c:GetSummonType()==SUMMON_TYPE_XYZ and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
end
function c511009079.negcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)	
	return e:GetHandler():GetFlagEffect(32134638)==0 and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) 
		and g and g:IsExists(c511009079.tfilter,1,e:GetHandler(),tp) and Duel.IsChainDisablable(ev)
end
function c511009079.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(32134638,1)) then
		e:GetHandler():RegisterFlagEffect(32134638,RESET_EVENT+0x1fe0000,0,1)
		Duel.NegateEffect(ev)
	end
end

