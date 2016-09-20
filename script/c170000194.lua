--Goddess Bow
function c170000194.initial_effect(c)
    --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,25652259,46232525,1,true,true)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c170000194.target)
	e1:SetOperation(c170000194.operation)
	c:RegisterEffect(e1)
	--Double ATK
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetValue(c170000194.atkval)
	c:RegisterEffect(e2)
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--Activates a monster effect they control
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_F)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(c170000194.con)
	e4:SetOperation(c170000194.op)
	c:RegisterEffect(e4)
end
function c170000194.hermos_filter(c)
	return c:IsCode(25652259)
end
function c170000194.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c170000194.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsLocation(LOCATION_SZONE) and tc:IsLocation(LOCATION_MZONE) then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c170000194.atkval(e,c)
	return c:GetBaseAttack()*2
end
function c170000194.indes(e,c)
	return c:GetAttack()==e:GetHandler():GetEquipTarget():GetAttack()
end
function c170000194.con(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	return not e:GetHandler():GetEquipTarget():IsStatus(STATUS_BATTLE_DESTROYED) and ep~=tp
		and ph>PHASE_MAIN1 and ph<PHASE_MAIN2 and re:IsActiveType(TYPE_MONSTER)
		and ((Duel.GetAttacker() and Duel.GetAttacker()==e:GetHandler():GetEquipTarget()) 
		or (Duel.GetAttackTarget() and Duel.GetAttackTarget()==e:GetHandler():GetEquipTarget()))
end
function c170000194.op(e,tp,eg,ep,ev,re,r,rp)
	local et=e:GetHandler():GetEquipTarget()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
	e1:SetValue(1)
    et:RegisterEffect(e1)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetValue(1)
	e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	et:RegisterEffect(e3)
end
