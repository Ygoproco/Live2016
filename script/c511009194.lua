--Lyrical Luscinia - Independent Nightingale
--fixed by MLD
function c511009194.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,511009193,aux.FilterBoolFunction(Card.IsFusionSetCard,0x1f8),1,true,true)
	--level
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c511009194.valcheck)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_LEVEL)
	e2:SetCondition(c511009194.lvcon)
	e2:SetValue(c511009194.lvval)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--Atk update
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SET_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c511009194.atkval)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(17415895,0))
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c511009194.target)
	e4:SetOperation(c511009194.operation)
	c:RegisterEffect(e4)
end
function c511009194.valcheck(e,c)
	local g=c:GetMaterial()
	local lvl=0
	local tc=g:GetFirst()
	if not tc then return end
	if not tc:IsCode(511009193) then tc=g:GetNext() end
	if tc:IsCode(511009193) then
		lvl=tc:GetOverlayCount()
	end
	e:SetLabel(lvl)
end
function c511009194.lvcon(e)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c511009194.lvval(e,c)
	return e:GetLabelObject():GetLabel()
end
function c511009194.atkval(e,c)
	local c=e:GetHandler()
	local atk=c:GetBaseAttack()+(c:GetLevel()*500)
	if atk<0 then atk=0 end
	return atk
end
function c511009194.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetLevel()>0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c511009194.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local dam=e:GetHandler():GetLevel()*500
	Duel.Damage(p,dam,REASON_EFFECT)
end
