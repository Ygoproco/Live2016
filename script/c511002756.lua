--追走の翼
function c511002756.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c511002756.target)
	e1:SetOperation(c511002756.operation)
	c:RegisterEffect(e1)
end
function c511002756.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
function c511002756.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		c:SetCardTarget(tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_OWNER_RELATE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetCondition(c511002756.rcon)
		e1:SetValue(1)
		tc:RegisterEffect(e1,true)
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(42776855,0))
		e3:SetCategory(CATEGORY_DESTROY)
		e3:SetType(EFFECT_TYPE_QUICK_O)
		e3:SetCode(EVENT_BATTLE_START)
		e3:SetRange(LOCATION_SZONE)
		e3:SetCondition(c511002756.atkcon)
		e3:SetTarget(c511002756.atktg)
		e3:SetOperation(c511002756.atkop)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e3)
	end
end
function c511002756.rcon(e)
	return e:GetOwner():IsHasCardTarget(e:GetHandler())
end
function c511002756.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetFirstCardTarget()
	if not tc then return false end
	local bc=tc:GetBattleTarget()
	return tc and tc:IsLocation(LOCATION_MZONE) and bc and bc:IsFaceup() and bc:IsLocation(LOCATION_MZONE) and bc:IsLevelAbove(5) 
		and bc==Duel.GetAttacker()
end
function c511002756.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(42776855)==0 end
	e:GetHandler():RegisterFlagEffect(42776855,RESET_CHAIN,0,1)
end
function c511002756.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=c:GetFirstCardTarget()
	if not tc then return false end
	local bc=tc:GetBattleTarget()
	local atk=bc:GetAttack()
	if bc:IsRelateToBattle() and Duel.Destroy(bc,REASON_EFFECT)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
