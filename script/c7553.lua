--十二獣ドランシア
--Juunishishi Drancia
--Scripted by Eerie Code
function c7553.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,4,c7553.ovfilter,aux.Stringid(7553,0),4,c7553.xyzop)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c7553.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c7553.defval)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(7553,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c7553.descost)
	e3:SetTarget(c7553.destg)
	e3:SetOperation(c7553.desop)
	c:RegisterEffect(e3)
end

function c7553.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf2) and not c:IsCode(7553)
end
function c7553.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,7553)==0 end
	Duel.RegisterFlagEffect(tp,7553,RESET_PHASE+PHASE_END,0,1)
end

function c7553.adfil(c)
	return c:IsSetCard(0xf2) and c:IsType(TYPE_MONSTER)
end
function c7553.atkval(e,c)
	return c:GetOverlayGroup():Filter(c7553.adfil,nil):GetSum(Card.GetAttack)
end
function c7553.defval(e,c)
	return c:GetOverlayGroup():Filter(c7553.adfil,nil):GetSum(Card.GetDefense)
end

function c7553.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c7553.desfil(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c7553.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c7553.desfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c7553.desfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c7553.desfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c7553.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
