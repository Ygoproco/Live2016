--十二獣ワイルドボウ
--Juunishishi Wildbow
--Scripted by Eerie Code
function c74393852.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,5,c74393852.ovfilter,aux.Stringid(74393852,0),5,c74393852.xyzop)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c74393852.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c74393852.defval)
	c:RegisterEffect(e2)
	--direct atk
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e6)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(74393852,1))
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_POSITION)
	e4:SetCondition(c74393852.tgcon)
	e4:SetTarget(c74393852.tgtg)
	e4:SetOperation(c74393852.tgop)
	c:RegisterEffect(e4)
end

function c74393852.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf1) and not c:IsCode(74393852)
end
function c74393852.xyzop(e,tp,chk)
  if chk==0 then return Duel.GetFlagEffect(tp,74393852)==0 end
  Duel.RegisterFlagEffect(tp,74393852,RESET_PHASE+PHASE_END,0,1)
end

function c74393852.adfil(c)
	return c:IsSetCard(0xf1) and c:IsType(TYPE_MONSTER)
end
function c74393852.atkval(e,c)
	return c:GetOverlayGroup():Filter(c74393852.adfil,nil):Filter(Card.IsAttackAbove,nil,1):GetSum(Card.GetAttack)
end
function c74393852.defval(e,c)
	return c:GetOverlayGroup():Filter(c74393852.adfil,nil):Filter(Card.IsDefenseAbove,nil,1):GetSum(Card.GetDefense)
end

function c74393852.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetHandler():GetOverlayCount()>=12
end
function c74393852.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND+LOCATION_ONFIELD)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c74393852.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND+LOCATION_ONFIELD)
	if Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
		end
	end
end
