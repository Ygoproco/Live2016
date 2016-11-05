--十二獣ドランシア
--Juunishishi Drancia
--Scripted by Eerie Code
function c48905153.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,4,c48905153.ovfilter,aux.Stringid(48905153,0),4,c48905153.xyzop)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c48905153.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c48905153.defval)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(48905153,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c48905153.descost)
	e3:SetTarget(c48905153.destg)
	e3:SetOperation(c48905153.desop)
	c:RegisterEffect(e3)
end

function c48905153.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf1) and not c:IsCode(48905153)
end
function c48905153.xyzop(e,tp,chk)
  if chk==0 then return Duel.GetFlagEffect(tp,48905153)==0 end
  Duel.RegisterFlagEffect(tp,48905153,RESET_PHASE+PHASE_END,0,1)
end

function c48905153.adfil(c)
	return c:IsSetCard(0xf1) and c:IsType(TYPE_MONSTER)
end
function c48905153.atkval(e,c)
	return c:GetOverlayGroup():Filter(c48905153.adfil,nil):Filter(Card.IsAttackAbove,nil,1):GetSum(Card.GetAttack)
end
function c48905153.defval(e,c)
	return c:GetOverlayGroup():Filter(c48905153.adfil,nil):Filter(Card.IsDefenseAbove,nil,1):GetSum(Card.GetDefense)
end

function c48905153.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c48905153.desfil(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c48905153.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c48905153.desfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c48905153.desfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c48905153.desfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c48905153.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
