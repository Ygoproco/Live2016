--古代の機械合成竜
--Ancient Gear Hydra
--Scripted by Eerie Code
function c81269231.initial_effect(c)
	--mat check
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c81269231.valcheck)
	c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(c81269231.regcon)
	e2:SetOperation(c81269231.regop)
	c:RegisterEffect(e2)
	e2:SetLabelObject(e1)
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(c81269231.aclimit)
	e3:SetCondition(c81269231.actcon)
	c:RegisterEffect(e3)	
end

function c81269231.valcheck(e,c)
	local g=c:GetMaterial()
	local flag=0
	local tc=g:GetFirst()
	while tc do
		if tc:IsSetCard(0x7) then
			flag=bit.bor(flag,0x1)
		end
		if tc:IsSetCard(0x51) then
			flag=bit.bor(flag,0x2)
		end
		tc=g:GetNext()
	end
	e:SetLabel(flag)
end

function c81269231.regcon(e,tp,eg,ep,ev,re,r,rp)
	--return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_ADVANCE)==SUMMON_TYPE_ADVANCE
end
function c81269231.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local flag=e:GetLabelObject():GetLabel()
	if bit.band(flag,0x1)~=0 then
		--remove
		local e7=Effect.CreateEffect(c)
		e7:SetCategory(CATEGORY_REMOVE)
		e7:SetDescription(aux.Stringid(81269231,0))
		e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e7:SetCode(EVENT_DAMAGE_STEP_END)
		e7:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e7:SetCondition(c81269231.rmcon)
		e7:SetTarget(c81269231.rmtg)
		e7:SetOperation(c81269231.rmop)
		e7:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e7)
	end
	if bit.band(flag,0x2)~=0 then
		local e4=Effect.CreateEffect(c)
		e4:SetDescription(aux.Stringid(81269231,1))
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_ATTACK_ALL)
		e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e4:SetValue(1)
		e4:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e4)
	end
end
function c81269231.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	e:SetLabelObject(bc)
	return ((c==Duel.GetAttacker() and bc) or c==Duel.GetAttackTarget()) and c:IsStatus(STATUS_OPPO_BATTLE) and bc:IsOnField() and bc:IsRelateToBattle()
end
function c81269231.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetLabelObject():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetLabelObject(),1,0,0)
end
function c81269231.rmop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetLabelObject()
	if bc:IsRelateToBattle() then
		Duel.Remove(bc,POS_FACEUP,REASON_EFFECT)
	end
end

function c81269231.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) or (re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e))
end
function c81269231.actcon(e)
	local atk=Duel.GetAttacker()
	return atk and atk:IsSetCard(0x7) and atk:IsControler(e:GetHandlerPlayer())
end
